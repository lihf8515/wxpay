## 微信支付API接口模块，用户最终的微信支付相关的调用都应该调用此模块的相关函数
## 刷卡支付实现,实现了一个刷卡支付的流程，流程如下：
## 1、提交刷卡支付,
## 2、根据返回结果决定是否需要查询订单，如果查询之后订单还未变则需要返回查询（一般反复查10次）,
## 3、如果反复查询10订单依然不变，则发起撤销订单,
## 4、撤销订单需要循环撤销，一直撤销成功为止（注意循环次数，建议10次）

import tables, os

import wxpay/private/utils
import wxpay/exception
import wxpay/micropay
import wxpay/orderquery
import wxpay/reverse
import wxpay/refunda

proc query(config: WxPayData, outTradeNo: string,
           succCode: var int): WxPayData =
  ## 查询订单情况,succCode: 0表示订单不成功，1表示订单成功，2表示继续等待
  ## 返回查询结果
  # 初始化订单查询请求数据
  var inputData = WxPayData()
  inputData["out_trade_no"] = outTradeNo
  let ret = orderQuery(inputData, config)
  if ret["return_code"] == "SUCCESS" and ret["result_code"] == "SUCCESS":
    if ret["trade_state"] == "SUCCESS": ## 支付成功
      succCode = 1
      return
    elif ret["trade_state"] == "USERPAYING": ## 用户支付中
      succCode = 2
      return
  ## 如果返回错误码为“此交易订单号不存在”则直接认定失败
  if ret["err_code"] == "ORDERNOTEXIST":
    succCode = 0
  else: ## 如果是系统错误，则后续继续
    succCode = 2
  result = ret

proc cancel(config: WxPayData, outTradeNo: string,
            depth = 0): bool =
  ## 撤销订单，如果失败会重复调用10次
  try:
    if depth > 10:
      return false
    # 初始化订单查询请求数据
    var inputData = WxPayData()
    inputData["out_trade_no"] = outTradeNo
    var ret = reverse(inputData, config)
    ## 接口调用失败
    if ret["return_code"] != "SUCCESS":
      return false
    ## 如果结果为success且不需要重新调用撤销，则表示撤销成功
    if ret["result_code"] == "SUCCESS" and ret["recall"] == "N":
      return true
    elif ret["recall"] == "Y":
      return cancel(config, outTradeNo, depth + 1)
  except:
    return false

{.push stdcall dynlib exportc.}
proc wxMicropay*(input, config: WxPayData,
                 succFlag: var bool): WxPayData =
  ## 付款码支付，返回查询接口的结果
  ## 此函数将要导出到lib，供其他语言调用
  # 1、提交被扫支付
  var ret = micropay(input, config, 5)
  # 如果调用失败
  if not ret.hasKey("return_code"):
    raise newException(WxPayException, "支付接口调用失败！")
  if ret["return_code"] == "FAIL":
    succFlag = false
    return ret
  # 2、接口调用成功，明确返回调用失败
  if ret["return_code"] == "SUCCESS" and ret["result_code"] == "FAIL" and
     ret["err_code"] != "USERPAYING" and ret["err_code"] != "SYSTEMERROR":
    succFlag = false
    return ret
  # 3、确认支付是否成功
  var queryTimes = 10
  var succResult = 0
  var queryResult = WxPayData()
  # 取订单号
  let outTradeNo = input["out_trade_no"]
  while queryTimes > 0:
    succResult = 0
    queryResult = query(config, outTradeNo, succResult)
    if succResult == 2: # 如果需要等待2s后继续
      sleep(2000)
      continue
    elif succResult == 1: # 查询成功
      succFlag = true
      return ret
    else: # 订单交易失败
      break
    dec(queryTimes)
  # 4、10次确认失败，则撤销订单
  if not cancel(config, outTradeNo):
    raise newException(WxpayException, "撤销单失败！")
  succFlag = false # 到这里说明支付不成功
  return queryResult

proc wxRefund*(input, config: WxPayData,
               succFlag: var bool): WxPayData =
  ## 退款申请，返回申请受理结果
  ## 此函数将要导出到lib，供其他语言调用
  # 调用申请退款
  var ret = refund(input, config)
  # 如果调用失败
  if not ret.hasKey("return_code"):
    raise newException(WxPayException, "退款申请接口调用失败！")
  if ret["return_code"] == "FAIL":
    succFlag = false
    return ret
  # 调用成功
  if ret["return_code"] == "SUCCESS" and ret["result_code"] == "SUCCESS":
    succFlag = true
  else:
    succFlag = false
  result = ret

proc wxErrorMessage*(): string =
  result = errorMessage()

{.pop.}
