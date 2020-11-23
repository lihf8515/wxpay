import tables
import os

import wxpay/api

## 刷卡支付实现,实现了一个刷卡支付的流程，流程如下：
## 1、提交刷卡支付,
## 2、根据返回结果决定是否需要查询订单，如果查询之后订单还未变则需要返回查询（一般反复查10次）,
## 3、如果反复查询10订单依然不变，则发起撤销订单,
## 4、撤销订单需要循环撤销，一直撤销成功为止（注意循环次数，建议10次）

proc query(config: WxPayConfig, out_trade_no: string, succCode: var int): WxPayResults =
  ## 查询订单情况,succCode: 0 订单不成功，1表示订单成功，2表示继续等待
  ## 返回查询结果
  var queryOrderInput = WxPayOrderQuery()
  queryOrderInput.setOut_trade_no(out_trade_no)
  var wxPayApi = WxPayApi()
  result = wxPayApi.orderQuery(config, queryOrderInput)

  if result.getData("return_code") == "SUCCESS" and result.getData("result_code") == "SUCCESS":
    if result.getData("trade_state") == "SUCCESS": ## 支付成功
      succCode = 1
      return
    elif result.getData("trade_state") == "USERPAYING": ## 用户支付中
      succCode = 2
      return

  ## 如果返回错误码为“此交易订单号不存在”则直接认定失败
  if result.getData("err_code") == "ORDERNOTEXIST":
    succCode = 0
  else: ## 如果是系统错误，则后续继续
    succCode = 2

proc cancel(config: WxPayConfig, out_trade_no: string, depth = 0): bool =
  ## 撤销订单，如果失败会重复调用10次
  try:
    if depth > 10:
      return false

    var reverseOrder = WxPayReverse()
    reverseOrder.setOut_trade_no(out_trade_no)

    var wxPayApi = WxPayApi()
    var ret = wxPayApi.reverse(config, reverseOrder)

    ## 接口调用失败
    if ret.getData("return_code") != "SUCCESS":
      return false

    ## 如果结果为success且不需要重新调用撤销，则表示撤销成功
    if ret.getData("result_code") == "SUCCESS" and ret.getData("recall") == "N":
      return true
    elif ret.getData("recall") == "Y":
      return cancel(config, out_trade_no, depth + 1)
  except:
    return false

proc pay(microPayInput: WxPayMicroPay, config: WxPayConfig,
         succFlag: var bool): WxPayResults =
  ## 提交刷卡支付，并且确认结果，接口比较慢,
  ## 返回查询接口的结果

  #①、提交被扫支付
  var wxPayApi = WxPayApi()
  var ret = wxPayApi.micropay(config, microPayInput, 5)
  ## 如果调用失败
  if not ret.getValues.hasKey("return_code"):
    raise newException(WxPayException, "支付接口调用失败！")
  if ret.getData("return_code") == "FAIL":
    succFlag = false
    return ret
  ## 取订单号
  var out_trade_no = microPayInput.getOut_trade_no()

  ## ②、接口调用成功，明确返回调用失败
  if ret.getData("return_code") == "SUCCESS" and
     ret.getData("result_code") == "FAIL" and
     ret.getData("err_code") != "USERPAYING" and
     ret.getData("err_code") != "SYSTEMERROR":
    succFlag = false
    return ret

  ## ③、确认支付是否成功
  var queryTimes = 10
  var succResult = 0
  while queryTimes > 0:
    succResult = 0
    result = query(config, out_trade_no, succResult)
    ## 如果需要等待2s后继续
    if succResult == 2:
      sleep(2000)
      continue
    elif succResult == 1: ## 查询成功
      succFlag = true
      return
    else: ## 订单交易失败
      break
    dec(queryTimes)

  ## ④、10次确认失败，则撤销订单
  if not cancel(config, out_trade_no):
    raise newException(WxpayException, "撤销单失败！")

  succFlag = false

proc initConfig(config: OrderedTableRef[string, string]): WxPayConfig =
  # 根据用户输入的配置情况初始化配置对象
  var cfg = WxPayConfig()
  if config.hasKey("appid"):
    cfg.setAppId(config["appid"])
  if config.hasKey("appsecret"):
    cfg.setAppSecret(config["appsecret"])
  if config.hasKey("key"):
    cfg.setKey(config["key"])
  if config.hasKey("mch_id"):
    cfg.setMerchantId(config["mch_id"])
  if config.hasKey("notify_url"):
    cfg.setNotifyUrl(config["notify_url"])
  if config.hasKey("proxy_host") and config.hasKey("proxy_port"):
    cfg.setProxy(config["proxy_host"], config["proxy_port"])
  if config.hasKey("report_level"):
    cfg.setReportLevel(config["report_level"])
  if config.hasKey("sslcert_path") and config.hasKey("sslkey_path"):
    cfg.setSSLCertPath(config["sslcert_path"], config["sslkey_path"])
  if config.hasKey("sign_type"):
    cfg.setSignType(config["sign_type"])
  result = cfg

{.push dynlib exportc.}
proc wxmicropay*(data, config: OrderedTableRef[string, string],
                 succFlag: var bool): OrderedTableRef[string, string] =
  ## 微信付款码支付，返回查询接口的结果
  ## 此函数将要导出到lib,供其他语言调用
  # 根据用户输入的配置情况初始化配置对象
  var cfg = initConfig(config)
  var input = WxPayMicroPay()
  input.setAuth_code(data["auth_code"])
  input.setBody(data["body"])
  input.setTotal_fee(data["total_fee"])
  input.setOut_trade_no(data["out_trade_no"])
  ## 调用付款码支付
  var ret = pay(input, cfg, succFlag)
  result = ret.getValues()

proc wxrefund*(data, config: OrderedTableRef[string, string],
               succFlag: var bool): OrderedTableRef[string, string] =
  ## 微信申请退款，返回申请受理结果
  ## 此函数将要导出到lib,供其他语言调用
  var cfg = initConfig(config) # 根据用户输入的配置情况初始化配置对象
  var input = WxPayRefund()
  if data.hasKey("transaction_id") and data["transaction_id"] != "":
    input.setTransaction_id(data["transaction_id"])
  if data.hasKey("out_trade_no") and data["out_trade_no"] != "":
    input.setOut_trade_no(data["out_trade_no"])
  input.setTotal_fee(data["total_fee"])
  input.setRefund_fee(data["refund_fee"])
  input.setOut_refund_no(data["out_refund_no"])
  input.setOp_user_id(cfg.getMerchantId())
  ## 调用申请退款
  var wxPayApi = WxPayApi()
  var ret = wxPayApi.refund(cfg, input)
  ## 如果调用失败
  if not ret.getValues.hasKey("return_code"):
    raise newException(WxPayException, "退款接口调用失败！")
  if ret.getData("return_code") == "FAIL":
    succFlag = false
    return ret.getValues()
  ## 调用成功
  if ret.getData("return_code") == "SUCCESS" and ret.getData("result_code") == "SUCCESS":
    succFlag = true
  else:
    succFlag = false
  result = ret.getValues()
{.pop.}