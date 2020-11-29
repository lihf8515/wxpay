## 统一下单模块

import tables

import private/utils
import exception
import report

proc unifiedOrder*(input: var WxPayData, config: WxPayData,
                   timeOut = 6): WxPayData =
  ## 统一下单，input参数中out_trade_no、body、total_fee、trade_type必填,
  ## appid、mchid由config参数携带，spbill_create_ip、nonce_str由系统自动填入,
  # 检测必填参数
  if not input.hasKey("out_trade_no"):
    raise newException(WxPayException, "统一支付接口缺少必填参数：out_trade_no！")
  elif not input.hasKey("body"):
    raise newException(WxPayException, "统一支付接口缺少必填参数：body！")
  elif not input.hasKey("total_fee"):
    raise newException(WxPayException, "统一支付接口缺少必填参数：total_fee！")
  elif not input.hasKey("trade_type"):
    raise newException(WxPayException, "统一支付接口缺少必填参数：trade_type！")
  # 关联参数
  if input["trade_type"] == "JSAPI" and not input.hasKey("openid"):
    raise newException(WxPayException, "统一支付接口缺少必填参数openid！trade_type为JSAPI时，openid为必填参数！")
  if input["trade_type"] == "NATIVE" and not input.hasKey("product_id"):
    raise newException(WxPayException, "统一支付接口缺少必填参数product_id！trade_type为JSAPI时，product_id为必填参数！")
  # 初始化并返回有效的配置数据
  let configData = initConfig(config, typeUnifiedOrder)
  # 初始化撤销订单请求数据
  var inputData = WxPayData()
  # 异步通知url未设置，则使用配置文件中的url
  if not input.hasKey("notify_url") and config["notify_url"] != "":
    inputData["notify_url"] = config["notify_url"] # 异步通知url
  
  if input.hasKey("out_trade_no"):
    inputData["out_trade_no"] = input["out_trade_no"]

  if input.hasKey("body"):
    inputData["body"] = input["body"]

  if input.hasKey("total_fee"):
    inputData["total_fee"] = input["total_fee"]

  if input.hasKey("trade_type"):
    inputData["trade_type"] = input["trade_type"]

  if input.hasKey("openid"):
    inputData["openid"] = input["openid"]

  if input.hasKey("product_id"):
    inputData["product_id"] = input["product_id"]

  if input.hasKey("device_info"):
    inputData["device_info"] = input["device_info"]

  if input.hasKey("detail"):
    inputData["detail"] = input["detail"]

  if input.hasKey("attach"):
    inputData["attach"] = input["attach"]

  if input.hasKey("fee_type"):
    inputData["fee_type"] = input["fee_type"]

  if input.hasKey("fee_type"):
    inputData["fee_type"] = input["fee_type"]

  if input.hasKey("time_start"):
    inputData["time_start"] = input["time_start"]

  if input.hasKey("time_expire"):
    inputData["time_expire"] = input["time_expire"]

  if input.hasKey("goods_tag"):
    inputData["goods_tag"] = input["goods_tag"]

  inputData["appid"] = configData["appid"] # 设置公众账号ID  
  inputData["mch_id"] = configData["mch_id"] # 设置商户号  
  inputData["nonce_str"] = getNonceStr() # 设置随机字符串
  inputData["spbill_create_ip"] = getLocalIpAddr() # 设置调用微信支付API的机器IP
  discard inputData.setSign(configData) # 签名
  let xml = inputData.toXml()
  let url = "https://api.mch.weixin.qq.com/pay/unifiedorder"
  let startTimeStamp = getMillisecond() # 请求开始时间
  let response = postXmlCurl(configData, xml, url, false, timeOut)
  let ret = checkResults(configData, response) # 检测接口调用返回的xml字符串是否合法，并且将其转换为有序表返回
  reportCostTime(configData, url, startTimeStamp, ret) # 上报请求花费时间
  result = ret
