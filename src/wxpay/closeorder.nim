#
#
#         WeChat payment SDK for Nim
#        (c) Copyright 2020 Li Haifeng
#

## 关闭订单模块

import tables, strutils

import private/utils
import exception
import report

proc closeOrder*(input: var WxPayData, config: WxPayData,
                 timeOut = 6): WxPayData =
  ## 关闭订单，input参数中out_trade_no必填,
  ## appid、mchid由config参数携带，nonce_str由系统自动填入,
  # 检测必填参数
  if not input.hasKey("out_trade_no") or strip(input["out_trade_no"]) == "":
    raise newException(WxPayException, "关闭订单接口中，out_trade_no必填！")
  # 初始化并返回有效的配置数据
  let configData = initConfig(config, typeCloseOrder)
  # 初始化订单查询请求数据
  var inputData = WxPayData()
  inputData["out_trade_no"] = strip(input["out_trade_no"])
  inputData["appid"] = configData["appid"] # 设置公众账号ID
  inputData["mch_id"] = configData["mch_id"] # 设置商户号
  inputData["nonce_str"] = getNonceStr() # 设置随机字符串
  discard inputData.setSign(configData) # 签名
  let xml = inputData.toXml()
  let url = "https://api.mch.weixin.qq.com/pay/closeorder"
  let startTimeStamp = getMillisecond() # 请求开始时间
  let response = postXmlCurl(configData, xml, url, false, timeOut)
  let ret = checkResults(configData, response) # 检测接口调用返回的xml字符串是否合法，并且将其转换为有序表返回
  reportCostTime(configData, url, startTimeStamp, ret) # 上报请求花费时间
  result = ret
