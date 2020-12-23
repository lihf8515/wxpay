#
#
#         WeChat payment SDK for Nim
#        (c) Copyright 2020 Li Haifeng
#

## 退款申请模块

import tables

import private/utils
import exception
import report

proc refund*(input, config: WxPayData, timeOut = 6): WxPayData =
  ## 申请退款，input参数中out_trade_no、transaction_id至少填写一个,
  ## out_refund_no、total_fee、refund_fee为必填参数,
  ## appid、mchid由config参数携带，nonce_str由系统自动填入,
  # 检测必填参数
  if (not input.hasKey("out_trade_no") or input["out_trade_no"] == "") and
     (not input.hasKey("transaction_id") or input["transaction_id"] == ""):
    raise newException(WxPayException, "退款申请接口，商户订单号out_trade_no、微信支付订单号transaction_id至少填一个！")
  if not input.hasKey("out_refund_no") or input["out_refund_no"] == "":
    raise newException(WxPayException, "退款申请接口缺少必填参数：商户退款单号out_refund_no！")
  elif not input.hasKey("total_fee") or input["total_fee"] == "":
    raise newException(WxPayException, "退款申请接口缺少必填参数：订单金额total_fee！")
  elif not input.hasKey("refund_fee") or input["refund_fee"] == "":
    raise newException(WxPayException, "退款申请接口缺少必填参数：退款金额refund_fee！")
  # 初始化并返回有效的配置数据
  let configData = initConfig(config, typeRefund)
  # 初始化订单查询请求数据
  var inputData = WxPayData()
  inputData["out_refund_no"] = input["out_refund_no"]
  inputData["total_fee"] = input["total_fee"]
  inputData["refund_fee"] = input["refund_fee"]
  # 异步通知url未设置，则使用配置文件中的url
  if not input.hasKey("notify_url") and configData["notify_url"] != "":
    inputData["notify_url"] = configData["notify_url"] # 异步通知url
    
  if input.hasKey("out_trade_no"):
    inputData["out_trade_no"] = input["out_trade_no"]

  if input.hasKey("transaction_id"):
    inputData["transaction_id"] = input["transaction_id"]
  
  if input.hasKey("refund_desc"):
    inputData["refund_desc"] = input["refund_desc"]
    
  if input.hasKey("device_info"):
    inputData["device_info"] = input["device_info"]

  if input.hasKey("refund_fee_type"):
    inputData["refund_fee_type"] = input["refund_fee_type"]

  if input.hasKey("refund_fee_type"):
    inputData["refund_fee_type"] = input["refund_fee_type"]

  inputData["appid"] = configData["appid"] # 设置公众账号ID
  inputData["mch_id"] = configData["mch_id"] # 设置商户号
  inputData["nonce_str"] = getNonceStr() # 设置随机字符串
  discard inputData.setSign(configData) # 签名
  let xml = inputData.toXml()
  let url = "https://api.mch.weixin.qq.com/secapi/pay/refund"
  let startTimeStamp = getMillisecond() # 请求开始时间
  let response = postXmlCurl(configData, xml, url, true, timeOut)
  let ret = checkResults(configData, response) # 检测接口调用返回的xml字符串是否合法，并且将其转换为有序表返回
  reportCostTime(configData, url, startTimeStamp, ret) # 上报请求花费时间
  result = ret

