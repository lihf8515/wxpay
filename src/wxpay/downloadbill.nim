## 下载对账单模块

import tables

import private/utils
import exception

proc downloadBill*(input: var WxPayData, config: WxPayData,
                   timeOut = 6): string =
  ## 下载对账单，input参数中bill_date为必填参数,
  ## appid、mchid由config参数携带，nonce_str由系统自动填入,
  # 检测必填参数
  if not input.hasKey("bill_date"):
    raise newException(WxPayException, "对账单接口中，缺少必填参数bill_date！")
  # 初始化并返回有效的配置数据
  let configData = initConfig(config, typeDownloadBill)
  # 初始化订单查询请求数据
  var inputData = WxPayData()
  if input.hasKey("bill_type"):
    inputData["bill_type"] = input["bill_type"]
  inputData["bill_date"] = input["bill_date"]
  inputData["appid"] = configData["appid"] # 设置公众账号ID
  inputData["mch_id"] = configData["mch_id"] # 设置商户号
  inputData["nonce_str"] = getNonceStr() # 设置随机字符串
  discard inputData.setSign(configData) # 签名
  let xml = inputData.toXml()
  let url = "https://api.mch.weixin.qq.com/pay/downloadbill"
  let response = postXmlCurl(configData, xml, url, false, timeOut)
  if response[0..4] == "<xml>":
    result = ""
  else:
    result = response

