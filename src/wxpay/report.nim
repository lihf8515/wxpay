#
#
#         WeChat payment SDK for Nim
#        (c) Copyright 2020 Li Haifeng
#

## 测速上报（交易保障）模块，此模块不需要由用户调用

import strutils, tables

import private/utils
import exception

proc report*(inputData: var WxPayData, configData: WxPayData,
             timeOut = 1): string =
  ## 测速上报，该方法使用时请注意异常流程，此函数不需要由用户调用
  ## inputData中interface_url、return_code、result_code、user_ip、execute_time_必填,
  ## appid、mch_id由config参数携带，user_ip、nonce_str、time由系统自动填入
  ## 成功时返回，其他抛异常
  # 检测必填参数
  if not inputData.hasKey("interface_url"):
    raise newException(WxPayException, "测速上报接口缺少必填参数：接口地址interface_url！")
  elif not inputData.hasKey("return_code"):
    raise newException(WxPayException, "测速上报接口缺少必填参数：返回状态码return_code！")
  elif not inputData.hasKey("result_code"):
    raise newException(WxPayException, "测速上报接口缺少必填参数：业务结果result_code！")
  elif not inputData.hasKey("execute_time_"):
    raise newException(WxPayException, "测速上报接口缺少必填参数：接口耗时execute_time_！")
  inputData["appid"] = configData["appid"] # 设置微信分配的公众账号ID
  inputData["mch_id"] = configData["mch_id"] # 设置微信支付分配的商户号
  inputData["user_ip"]= getLocalIpAddr() # 设置发起接口调用时的机器IP
  # 设置上报时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。其他详见时间规则
  inputData["time"] = getCurrentTime()
  inputData["nonce_str"] = getNonceStr() # 设置随机字符串，不长于32位。推荐随机数生成算法
  discard inputData.setSign(configData) # 签名
  let xml = inputData.toXml()
  let url = "https://api.mch.weixin.qq.com/payitil/report"
  let response = postXmlCurl(configData, xml, url, false, timeOut)
  result = response

proc reportCostTime*(configData: WxPayData,
                     url, startTimeStamp: string,
                     reportData: WxPayData) =
  ## 上报数据，上报的时候将屏蔽所有异常流程，此函数不需要由用户调用
  # 如果不需要上报数据
  let reportLevenl = configData["report_level"]
  if reportLevenl == "0": return
  # 如果仅失败上报
  if reportLevenl == "1" and reportData.hasKey("return_code") and
     reportData["return_code"] == "SUCCESS" and
     reportData.hasKey("result_code") and
     reportData["result_code"] == "SUCCESS":
       return
  # 上报逻辑
  var endTimeStamp = getMillisecond()
  var inputData = WxPayData() # 初始化上报请求数据
  # 设置上报对应的接口的完整URL，类似：https://api.mch.weixin.qq.com/pay/unifiedorder,
  # 对于被扫支付，为更好的和商户共同分析一次业务行为的整体耗时情况，
  # 对于两种接入模式，请都在门店侧对一次被扫行为进行一次单独的整体上报，
  # 上报URL指定为：https://api.mch.weixin.qq.com/pay/micropay/total关于两种接入,
  # 模式具体可参考本文档章节：被扫支付商户接入模式其它接口调用仍然按照调用一次，上报一次来进行
  inputData["interface_url"] = url
  # 设置接口耗时情况，单位为毫秒
  inputData["execute_time_"] = $(parseInt(endTimeStamp) - parseInt(startTimeStamp))
  # 设置返回码，SUCCESS/FAIL,此字段是通信标识，非交易标识，交易是否成功需要查看trade_state来判断
  if reportData.hasKey("return_code"):
    inputData["return_code"] = reportData["return_code"]
  # 设置返回信息，如非空，为错误原因签名失败参数格式校验错误
  if reportData.hasKey("return_msg"):
    inputData["return_msg"] = reportData["return_msg"]
  # 设置业务结果，SUCCESS/FAIL
  if reportData.hasKey("result_code"):
    inputData["result_code"] = reportData["result_code"]
  # 设置错误代码，ORDERNOTEXIST—订单不存在，SYSTEMERROR—系统错误
  if reportData.hasKey("err_code"):
    inputData["err_code"] = reportData["err_code"]
  # 设置错误代码描述
  if reportData.hasKey("err_code_des"):
    inputData["err_code_des"] = reportData["err_code_des"]
  # 设置商户系统内部的订单号,商户可以在上报时提供相关商户订单号方便微信支付更好的提高服务质量
  if reportData.hasKey("out_trade_no"):
    inputData["out_trade_no"] = reportData["out_trade_no"]
  # 设置微信支付分配的终端设备号，商户自定义
  if reportData.hasKey("device_info"):
    inputData["device_info"] = reportData["device_info"]
  discard report(inputData, configData)
