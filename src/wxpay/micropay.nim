#
#
#         WeChat payment SDK for Nim
#        (c) Copyright 2020 LiHaiFeng
#

## 被扫支付（付款码支付）模块

import tables

import private/utils
import exception
import report

proc micropay*(input, config: WxPayData, timeOut = 10): WxPayData =
  ## 提交被扫支付API,收银员使用扫码设备读取微信用户刷卡授权码以后，
  ## 二维码或条码信息传送至商户收银台，
  ## 由商户收银台或者商户后台调用该接口发起支付，返回接口调用的结果，
  ## input参数中body、out_trade_no、total_fee、auth_code必填，
  ## appid、mch_id由config参数携带，spbill_create_ip、nonce_str由系统自动填入
  # 检测必填参数
  if not input.hasKey("body"):
    raise newException(WxPayException, "提交被扫支付接口缺少必填参数：商品描述body！")
  elif not input.hasKey("out_trade_no"):
    raise newException(WxPayException, "提交被扫支付接口缺少必填参数：商户订单号out_trade_no！")
  elif not input.hasKey("total_fee"):
    raise newException(WxPayException, "提交被扫支付接口缺少必填参数：订单金额total_fee！")
  elif not input.hasKey("auth_code"):
    raise newException(WxPayException, "提交被扫支付接口缺少必填参数：付款码auth_code！")
  # 初始化并返回有效的配置数据
  var configData = initConfig(config, typeMicroPay)
  # 初始化被扫支付请求数据
  var inputData = WxPayData()
  # 设置商品或支付单简要描述
  inputData["body"] = input["body"]
  # 设置商户系统内部的订单号,32个字符内、可包含字母, 其他说明见商户订单号
  inputData["out_trade_no"] = input["out_trade_no"]
  # 设置订单总金额，单位为分，只能为整数，详见支付金额
  inputData["total_fee"] = input["total_fee"]
  # 设置扫码支付授权码，即设备读取用户微信中的条码或者二维码信息
  inputData["auth_code"] = input["auth_code"]  
  # 设置终端设备号(商户自定义，如门店编号) 
  if input.hasKey("device_info"):
    inputData["device_info"] = input["device_info"]
  # 设置商品名称明细列表
  if input.hasKey("detail"):
    inputData["detail"] = input["device_info"]
  # 设置附加数据，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
  if input.hasKey("attach"):
    inputData["attach"] = input["attach"]
  # 设置符合ISO 4217标准的三位字母代码，默认人民币：CNY，其他值列表详见货币类型
  if input.hasKey("fee_type"):
    inputData["fee_type"] = input["fee_type"]
  # 设置订单生成时间，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010。详见时间规则
  if input.hasKey("time_start"):
    inputData["time_start"] = input["time_start"]
  # 设置订单失效时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。详见时间规则
  if input.hasKey("time_expire"):
    inputData["time_expire"] = input["time_expire"]
  # 设置商品标记，代金券或立减优惠功能的参数，说明详见代金券或立减优惠
  if input.hasKey("goods_tag"):
    inputData["goods_tag"] = input["goods_tag"]
  # 设置调用微信支付API的机器IP
  inputData["spbill_create_ip"] = getLocalIpAddr()
  # 设置公众账号ID
  inputData["appid"] = configData["appid"]
  # 设置商户号
  inputData["mch_id"] = configData["mch_id"]
  # 设置随机字符串
  inputData["nonce_str"] = getNonceStr()
  discard inputData.setSign(configData) # 签名
  let xml = inputData.toXml() # 签名后的数据转换成xml格式串
  let startTimeStamp = getMillisecond() # 请求开始时间
  let url = "https://api.mch.weixin.qq.com/pay/micropay" # 请求URL
  let response = postXmlCurl(configData, xml, url, false, timeOut) # 请求服务接口
  # 检测接口调用返回的xml字符串是否合法，并且将其转换为有序表返回
  let ret = checkResults(configData, response)
  reportCostTime(configData, url, startTimeStamp, ret) # 上报请求花费时间
  result = ret
