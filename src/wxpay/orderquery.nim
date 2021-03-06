#
#
#         WeChat payment SDK for Nim
#        (c) Copyright 2020 Li Haifeng
#

## 订单查询模块

import tables

import private/utils
import exception
import report

proc orderQuery*(input: var WxPayData, config: WxPayData,
                 timeOut = 6): WxPayData =
  ## 查询订单，input参数中out_trade_no和transaction_id至少填写一个,
  ## 建议优先使用transaction_id查询，
  ## appid、mch_id由config参数携带，nonce_str由系统自动填入
  # 检测必填参数
  if (not input.hasKey("out_trade_no") or input["out_trade_no"] == "") and
     (not input.hasKey("transaction_id") or input["transaction_id"] == ""):
    raise newException(WxPayException,
                       "订单查询接口，商户订单号out_trade_no、微信支付订单号transaction_id至少填一个！")
  # 初始化并返回有效的配置数据
  let configData = initConfig(config, typeOrderQuery)
  # 初始化订单查询请求数据
  var inputData = WxPayData()
  if input.hasKey("out_trade_no"):
    inputData["out_trade_no"] = input["out_trade_no"]
  if input.hasKey("transaction_id"):
    inputData["transaction_id"] = input["transaction_id"]
  inputData["appid"] = configData["appid"] # 设置公众账号ID
  inputData["mch_id"] = configData["mch_id"] # 设置商户号
  inputData["nonce_str"] = getNonceStr() # 设置随机字符串
  discard inputData.setSign(configData) # 签名
  let xml = inputData.toXml()
  let url = "https://api.mch.weixin.qq.com/pay/orderquery"
  let startTimeStamp = getMillisecond() # 请求开始时间
  let response = postXmlCurl(configData, xml, url, false, timeOut)
  let ret = checkResults(configData, response) # 检测接口调用返回的xml字符串是否合法，并且将其转换为有序表返回
  reportCostTime(configData, url, startTimeStamp, ret) # 上报请求花费时间
  result = ret

