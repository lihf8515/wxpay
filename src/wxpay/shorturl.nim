#
#
#         WeChat payment SDK for Nim
#        (c) Copyright 2020 Li Haifeng
#

## 转换短链接模块

import tables

import private/utils
import exception
import report

proc shorturl*(input: var WxPayData, config: WxPayData,
               timeOut = 6): WxPayData =
  ## 转换短链接,该接口主要用于扫码原生支付模式一中的二维码链接转成短链接(weixin://wxpay/s/XXXXXX)，
  ## 减小二维码数据量，提升扫描速度和精确度。
  ## appid、mchid由config参数携带，nonce_str由系统自动填入,
  # 检测必填参数
  if not input.hasKey("long_url"):
    raise newException(WxPayException, "转换短链接接口缺少必填参数：URL（要签名需用原串，传输需URL encode）！")
  # 初始化并返回有效的配置数据
  let configData = initConfig(config, typeShortUrl)
  # 初始化撤销订单请求数据
  var inputData = WxPayData()
  inputData["long_url"] = input["long_url"]
  inputData["appid"] = configData["appid"] # 设置公众账号ID
  inputData["mch_id"] = configData["mch_id"] # 设置商户号
  inputData["nonce_str"] = getNonceStr() # 设置随机字符串
  discard inputData.setSign(configData) # 签名
  let xml = inputData.toXml()
  let url = "https://api.mch.weixin.qq.com/tools/shorturl"
  let startTimeStamp = getMillisecond() # 请求开始时间
  let response = postXmlCurl(configData, xml, url, false, timeOut)
  let ret = checkResults(configData, response) # 检测接口调用返回的xml字符串是否合法，并且将其转换为有序表返回
  reportCostTime(configData, url, startTimeStamp, ret) # 上报请求花费时间
  result = ret
