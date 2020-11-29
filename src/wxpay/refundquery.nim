## 退款查询模块

import tables

import private/utils
import exception
import report

proc refundQuery*(input, config: WxPayData, timeOut = 6): WxPayData =
  ## 查询退款,提交退款申请后，通过调用该接口查询退款状态。退款有一定延时，
  ## 用零钱支付的退款20分钟内到账，银行卡支付的退款3个工作日后重新查询退款状态。
  ## input参数中out_refund_no、out_trade_no、transaction_id、refund_id四个参数必填一个,
  ## appid、mchid由config参数携带，nonce_str由系统自动填入
  # 检测必填参数
  if not input.hasKey("out_refund_no") and not input.hasKey("out_trade_no") and 
     not input.hasKey("transaction_id") and not input.hasKey("refund_id"):
    raise newException(WxPayException, "退款查询接口，商户退款单号out_refund_no、"&
                       "商户订单号out_trade_no、微信支付订单号transaction_id、"&
                       "微信退款单号refund_id四个参数必填一个！")
  # 初始化并返回有效的配置数据
  let configData = initConfig(config, typeRefundQuery)
  # 初始化退款查询请求数据
  var inputData = WxPayData()
  if input.hasKey("out_refund_no"):
    inputData["out_refund_no"] = input["out_refund_no"]

  if input.hasKey("transaction_id"):
    inputData["transaction_id"] = input["transaction_id"]
  
  if input.hasKey("out_trade_no"):
    inputData["out_trade_no"] = input["out_trade_no"]

  if input.hasKey("refund_id"):
    inputData["refund_id"] = input["refund_id"]

  inputData["appid"] = configData["appid"] # 设置公众账号ID
  inputData["mch_id"] = configData["mch_id"] # 设置商户号
  inputData["nonce_str"] = getNonceStr() # 设置随机字符串
  discard inputData.setSign(configData) # 签名
  let xml = input.toXml()
  let url = "https://api.mch.weixin.qq.com/pay/refundquery"
  let startTimeStamp = getMillisecond() # 请求开始时间
  let response = postXmlCurl(configData, xml, url, false, timeOut)
  let ret = checkResults(config, response) # 检测接口调用返回的xml字符串是否合法，并且将其转换为有序表返回
  reportCostTime(config, url, startTimeStamp, ret) # 上报请求花费时间
  result = ret
