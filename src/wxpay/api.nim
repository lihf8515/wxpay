import random, times
import strutils
import tables
import net, httpclient

import exception
import config

import closeorder
import downloadbill
import micropay
import orderquery
import refund
import refundquery
import report
import reverse
import shorturl
import unifiedorder
import databasemd5
import results
import bizpayurl

export exception
export config

export closeorder
export downloadbill
export micropay
export orderquery
export refund
export refundquery
export report
export reverse
export shorturl
export unifiedorder
export databasemd5
export results
export bizpayurl

type WxPayApi* = ref object of RootObj
  ## 接口访问类，包含所有微信支付API列表的封装，
  ## 每个接口有默认超时时间（除提交被扫支付为10s，上报超时时间为1s外，其他均为6s）

const VERSION* = "3.0.10" # SDK版本号
randomize() # 初始化随机数发生器

proc getNonceStr(wxPayApi: WxPayApi, length = 32): string = 
  ## 产生随机字符串，不长于32位
  let chars = "abcdefghijklmnopqrstuvwxyz0123456789"
  var str = ""
  var pos = 0
  for i in countup(0, length - 1):
    pos = rand(chars.len - 1)
    str.add chars[pos .. pos]
  result = str

proc getMillisecond(wxPayApi: WxPayApi): string =
  ## 获取毫秒级别的时间戳
  let time = getTime()
  let unixTime = $time.toUnixFloat()
  let seqs = unixTime.split('.')
  result = seqs[0] & seqs[1][0..2]

proc postXmlCurl(wxPayApi: WxPayApi, config: WxPayConfig, xml, url: string,
                 useCert = false, second = 30): string =
  ## 以post方式提交xml到对应的接口url 
  var client: HttpClient
  var proxy: Proxy
  var proxyHost = "0.0.0.0"
  var proxyPort = "0"
  var certFilePath =""
  var keyFilePath = ""

  config.getProxy(proxyHost, proxyPort)
  # 如果有配置代理这里就设置代理
  if proxyHost != "0.0.0.0" and proxyPort != "0":
    proxy = newProxy(proxyHost & ":" & proxyPort)

  if useCert:
    config.getSSLCertPath(certFilePath, keyFilePath)
    var ssl = newContext(certFile = certFilePath, keyFile = keyFilePath)
    client = newHttpClient(proxy = proxy, sslContext = ssl, timeout = second * 1000)
  else:
    client = newHttpClient(proxy = proxy, timeout = second * 1000)

  client.headers = newHttpHeaders({ "Content-Type": "application/xml" }) # 设置header

  let response = client.request(url, httpMethod = HttpPost, body = xml)
  result = response.body

proc report*(wxPayApi: WxPayApi, config: WxPayConfig,
             inputObj: WxPayReport, timeOut = 1): string =
  ## 测速上报，该方法内部封装在report中，使用时请注意异常流程,
  ## WxPayReport中interface_url、return_code、result_code、user_ip、execute_time_必填,
  ## appid、mchid、spbill_create_ip、nonce_str不需要填入,
  ## 成功时返回，其他抛异常
  let url = "https://api.mch.weixin.qq.com/payitil/report"
  # 检测必填参数
  if not inputObj.isInterface_urlSet():
    raise newException(WxPayException, "接口URL，缺少必填参数interface_url！")
  elif not inputObj.isReturn_codeSet():
    raise newException(WxPayException, "返回状态码，缺少必填参数return_code！")
  elif not inputObj.isResult_codeSet():
    raise newException(WxPayException, "业务结果，缺少必填参数result_code！")
  elif not inputObj.isUser_ipSet():
    raise newException(WxPayException, "访问接口IP，缺少必填参数user_ip！")
  elif not inputObj.isExecute_time_Set():
    raise newException(WxPayException, "接口耗时，缺少必填参数execute_time_！")

  inputObj.setAppid(config.getAppId()) # 公众账号ID
  inputObj.setMch_id(config.getMerchantId()) # 商户号
  inputObj.setUser_ip($getPrimaryIPAddr()) # 终端ip
  inputObj.setTime(format(getTime(), "yyyyMMddHHmmss")) # 商户上报时间
  inputObj.setNonce_str(wxPayApi.getNonceStr()) # 随机字符串

  inputObj.setSign(config) # 签名
  let xml = inputObj.toXml()

  let response = wxPayApi.postXmlCurl(config, xml, url, false, timeOut)
  result = response

proc reportCostTime*(wxPayApi: WxPayApi, config: WxPayConfig,
                     url, startTimeStamp: string, data: WxPayResults) =
  ## 上报数据，上报的时候将屏蔽所有异常流程
  # 如果不需要上报数据
  let reportLevenl = config.getReportLevel()
  if reportLevenl == "0": return

  # 如果仅失败上报
  if reportLevenl == "1" and data.getValues.hasKey("return_code") and
     data.getData("return_code") == "SUCCESS" and
     data.getValues.hasKey("result_code") and
     data.getData("result_code") == "SUCCESS": return

  # 上报逻辑
  let endTimeStamp = wxPayApi.getMillisecond()
  var objInput = WxPayReport()
  objInput.setInterface_url(url)
  objInput.setExecute_time($(parseInt(endTimeStamp) - parseInt(startTimeStamp)))
  # 返回状态码
  if data.getValues.hasKey("return_code"):
    objInput.setReturn_code(data.getData("return_code"))

  # 返回信息
  if data.getValues.hasKey("return_msg"):
    objInput.setReturn_msg(data.getData("return_msg"))

  # 业务结果
  if data.getValues.hasKey("result_code"):
    objInput.setResult_code(data.getData("result_code"))

  # 错误代码
  if data.getValues.hasKey("err_code"):
    objInput.setErr_code(data.getData("err_code"))

  # 错误代码描述
  if data.getValues.hasKey("err_code_des"):
    objInput.setErr_code_des(data.getData("err_code_des"))

  # 商户订单号
  if data.getValues.hasKey("out_trade_no"):
    objInput.setOut_trade_no(data.getData("out_trade_no"))

  # 设备号
  if data.getValues.hasKey("device_info"):
    objInput.setDevice_info(data.getData("device_info"))

  try:
    discard wxPayApi.report(config, objInput)
  except:
    discard

proc unifiedOrder*(wxPayApi: WxPayApi, config: WxPayConfig,
                   inputObj: WxPayUnifiedOrder, timeOut = 6): WxPayResults =
  ## 统一下单，WxPayUnifiedOrder中out_trade_no、body、total_fee、trade_type必填,
  ## appid、mchid、spbill_create_ip、nonce_str不需要填入,
  ## 成功时返回，其他抛异常
  let url = "https://api.mch.weixin.qq.com/pay/unifiedorder"
  # 检测必填参数
  if not inputObj.isOut_trade_noSet():
    raise newException(WxPayException, "缺少统一支付接口必填参数out_trade_no！")
  elif not inputObj.isBodySet():
    raise newException(WxPayException, "缺少统一支付接口必填参数body！")
  elif not inputObj.isTotal_feeSet():
    raise newException(WxPayException, "缺少统一支付接口必填参数total_fee！")
  elif not inputObj.isTrade_typeSet():
    raise newException(WxPayException, "缺少统一支付接口必填参数trade_type！")

  # 关联参数
  if inputObj.getTrade_type() == "JSAPI" and not inputObj.isOpenidSet():
    raise newException(WxPayException, "统一支付接口中，缺少必填参数openid！trade_type为JSAPI时，openid为必填参数！")

  if inputObj.getTrade_type() == "NATIVE" and not inputObj.isProduct_idSet():
    raise newException(WxPayException, "统一支付接口中，缺少必填参数product_id！trade_type为JSAPI时，product_id为必填参数！")

  # 异步通知url未设置，则使用配置文件中的url
  if not inputObj.isNotify_urlSet() and config.getNotifyUrl() != "":
    inputObj.setNotify_url(config.getNotifyUrl()) # 异步通知url

  inputObj.setAppid(config.getAppId()) # 公众账号ID
  inputObj.setMch_id(config.getMerchantId()) # 商户号
  inputObj.setSpbill_create_ip($getPrimaryIPAddr()) # 终端ip         
  inputObj.setNonce_str(wxPayApi.getNonceStr()) # 随机字符串

  inputObj.setSign(config) # 签名
  let xml = inputObj.toXml()

  let startTimeStamp = wxPayApi.getMillisecond() # 请求开始时间
  let response = wxPayApi.postXmlCurl(config, xml, url, false, timeOut)
  var wxPayResults = WxPayResults() # 创建支付结果对象，并初始化Values为空表
  var data = OrderedTableRef[string, string]()
  wxPayResults.setValues(data)
  result = wxPayResults.init(config, response)
  wxPayApi.reportCostTime(config, url, startTimeStamp, result) # 上报请求花费时间

proc orderQuery*(wxPayApi: WxPayApi, config: WxPayConfig,
                 inputObj: WxPayOrderQuery, timeOut = 6): WxPayResults =
  ## 查询订单，WxPayOrderQuery中out_trade_no、transaction_id至少填一个,
  ## appid、mchid、spbill_create_ip、nonce_str不需要填入,
  ## 成功时返回，其他抛异常
  let url = "https://api.mch.weixin.qq.com/pay/orderquery"
  # 检测必填参数
  if not inputObj.isOut_trade_noSet() and not inputObj.isTransaction_idSet():
    raise newException(WxPayException, "订单查询接口中，out_trade_no、transaction_id至少填一个！")

  inputObj.setAppid(config.getAppId()) # 公众账号ID
  inputObj.setMch_id(config.getMerchantId()) # 商户号
  inputObj.setNonce_str(wxPayApi.getNonceStr()) # 随机字符串

  inputObj.setSign(config) # 签名
  let xml = inputObj.toXml()

  let startTimeStamp = wxPayApi.getMillisecond() # 请求开始时间
  let response = wxPayApi.postXmlCurl(config, xml, url, false, timeOut)
  var wxPayResults = WxPayResults() # 创建支付结果对象，并初始化Values为空表
  var data = OrderedTableRef[string, string]()
  wxPayResults.setValues(data)
  result = wxPayResults.init(config, response)
  wxPayApi.reportCostTime(config, url, startTimeStamp, result) # 上报请求花费时间

proc closeOrder*(wxPayApi: WxPayApi, config: WxPayConfig,
                 inputObj: WxPayCloseOrder, timeOut = 6): WxPayResults =
  ## 关闭订单，WxPayCloseOrder中out_trade_no必填,
  ## appid、mchid、spbill_create_ip、nonce_str不需要填入,
  ## 成功时返回，其他抛异常
  let url = "https://api.mch.weixin.qq.com/pay/closeorder"
  # 检测必填参数
  if not inputObj.isOut_trade_noSet():
    raise newException(WxPayException, "关闭订单接口中，out_trade_no必填！")

  inputObj.setAppid(config.getAppId()) # 公众账号ID
  inputObj.setMch_id(config.getMerchantId()) # 商户号
  inputObj.setNonce_str(wxPayApi.getNonceStr()) # 随机字符串

  inputObj.setSign(config) # 签名
  let xml = inputObj.toXml()

  let startTimeStamp = wxPayApi.getMillisecond() # 请求开始时间
  let response = wxPayApi.postXmlCurl(config, xml, url, false, timeOut)
  var wxPayResults = WxPayResults() # 创建支付结果对象，并初始化Values为空表
  var data = OrderedTableRef[string, string]()
  wxPayResults.setValues(data)
  result = wxPayResults.init(config, response)
  wxPayApi.reportCostTime(config, url, startTimeStamp, result) # 上报请求花费时间

proc refund*(wxPayApi: WxPayApi, config: WxPayConfig,
                 inputObj: WxPayRefund, timeOut = 6): WxPayResults =
  ## 申请退款，WxPayRefund中out_trade_no、transaction_id至少填一个且,
  ## out_refund_no、total_fee、refund_fee、op_user_id为必填参数,
  ## appid、mchid、spbill_create_ip、nonce_str不需要填入,
  ## 成功时返回，其他抛异常
  let url = "https://api.mch.weixin.qq.com/secapi/pay/refund"
  # 检测必填参数
  if not inputObj.isOut_trade_noSet() and not inputObj.isTransaction_idSet():
    raise newException(WxPayException, "退款申请接口中，out_trade_no、transaction_id至少填一个！")
  elif not inputObj.isOut_refund_noSet():
    raise newException(WxPayException, "退款申请接口中，缺少必填参数out_refund_no！")
  elif not inputObj.isTotal_feeSet():
    raise newException(WxPayException, "退款申请接口中，缺少必填参数total_fee！")
  elif not inputObj.isRefund_feeSet():
    raise newException(WxPayException, "退款申请接口中，缺少必填参数refund_fee！")
  elif not inputObj.isOp_user_idSet():
    raise newException(WxPayException, "退款申请接口中，缺少必填参数op_user_id！")

  inputObj.setAppid(config.getAppId()) # 公众账号ID
  inputObj.setMch_id(config.getMerchantId()) # 商户号
  inputObj.setNonce_str(wxPayApi.getNonceStr()) # 随机字符串

  inputObj.setSign(config) # 签名
  let xml = inputObj.toXml()

  let startTimeStamp = wxPayApi.getMillisecond() # 请求开始时间
  let response = wxPayApi.postXmlCurl(config, xml, url, true, timeOut)
  var wxPayResults = WxPayResults() # 创建支付结果对象，并初始化Values为空表
  var data = OrderedTableRef[string, string]()
  wxPayResults.setValues(data)
  result = wxPayResults.init(config, response)
  wxPayApi.reportCostTime(config, url, startTimeStamp, result) # 上报请求花费时间

proc refundQuery*(wxPayApi: WxPayApi, config: WxPayConfig,
                 inputObj: WxPayRefundQuery, timeOut = 6): WxPayResults =
  ## 查询退款,提交退款申请后，通过调用该接口查询退款状态。退款有一定延时，
  ## 用零钱支付的退款20分钟内到账，银行卡支付的退款3个工作日后重新查询退款状态。
  ## WxPayRefundQuery中out_refund_no、out_trade_no、transaction_id、refund_id四个参数必填一个,
  ## appid、mchid、spbill_create_ip、nonce_str不需要填入,
  ## 成功时返回，其他抛异常
  let url = "https://api.mch.weixin.qq.com/pay/refundquery"
  # 检测必填参数
  if not inputObj.isOut_refund_noSet() and not inputObj.isOut_trade_noSet() and 
     not inputObj.isTransaction_idSet() and not inputObj.isRefund_idSet():
    raise newException(WxPayException, "退款查询接口中，out_refund_no、out_trade_no、transaction_id、refund_id四个参数必填一个！")

  inputObj.setAppid(config.getAppId()) # 公众账号ID
  inputObj.setMch_id(config.getMerchantId()) # 商户号
  inputObj.setNonce_str(wxPayApi.getNonceStr()) # 随机字符串

  inputObj.setSign(config) # 签名
  let xml = inputObj.toXml()

  let startTimeStamp = wxPayApi.getMillisecond() # 请求开始时间
  let response = wxPayApi.postXmlCurl(config, xml, url, false, timeOut)
  var wxPayResults = WxPayResults() # 创建支付结果对象，并初始化Values为空表
  var data = OrderedTableRef[string, string]()
  wxPayResults.setValues(data)
  result = wxPayResults.init(config, response)
  wxPayApi.reportCostTime(config, url, startTimeStamp, result) # 上报请求花费时间

proc downloadBill*(wxPayApi: WxPayApi, config: WxPayConfig,
                 inputObj: WxPayDownloadBill, timeOut = 6): string =
  ## 下载对账单，WxPayDownloadBill中bill_date为必填参数,
  ## appid、mchid、spbill_create_ip、nonce_str不需要填入,
  ## 成功时返回，其他抛异常
  let url = "https://api.mch.weixin.qq.com/pay/downloadbill"
  # 检测必填参数
  if not inputObj.isBill_dateSet():
    raise newException(WxPayException, "对账单接口中，缺少必填参数bill_date！")

  inputObj.setAppid(config.getAppId()) # 公众账号ID
  inputObj.setMch_id(config.getMerchantId()) # 商户号
  inputObj.setNonce_str(wxPayApi.getNonceStr()) # 随机字符串

  inputObj.setSign(config) # 签名
  let xml = inputObj.toXml()

  let response = wxPayApi.postXmlCurl(config, xml, url, false, timeOut)
  if response[0..4] == "<xml>":
    result = ""

  result = response

proc micropay*(wxPayApi: WxPayApi, config: WxPayConfig,
               inputObj: WxPayMicroPay, timeOut = 10): WxPayResults =
  ## 提交被扫支付API,收银员使用扫码设备读取微信用户刷卡授权码以后，二维码或条码信息传送至商户收银台，
  ## 由商户收银台或者商户后台调用该接口发起支付。
  ## WxPayMicroPay中body、out_trade_no、total_fee、auth_code参数必填,
  ## appid、mchid、spbill_create_ip、nonce_str不需要填入,
  let url = "https://api.mch.weixin.qq.com/pay/micropay"
  # 检测必填参数
  if not inputObj.isBodySet():
    raise newException(WxPayException, "提交被扫支付API接口中，缺少必填参数body！")
  elif not inputObj.isOut_trade_noSet():
    raise newException(WxPayException, "提交被扫支付API接口中，缺少必填参数out_trade_no！")
  elif not inputObj.isTotal_feeSet():
    raise newException(WxPayException, "提交被扫支付API接口中，缺少必填参数total_fee！")
  elif not inputObj.isAuth_codeSet():
    raise newException(WxPayException, "提交被扫支付API接口中，缺少必填参数auth_code！")

  inputObj.setSpbill_create_ip($getPrimaryIPAddr()) # 终端ip
  inputObj.setAppid(config.getAppId()) # 公众账号ID
  inputObj.setMch_id(config.getMerchantId()) # 商户号
  inputObj.setNonce_str(wxPayApi.getNonceStr()) # 随机字符串

  inputObj.setSign(config) # 签名
  let xml = inputObj.toXml()

  let startTimeStamp = wxPayApi.getMillisecond() # 请求开始时间
  let response = wxPayApi.postXmlCurl(config, xml, url, false, timeOut)
  var wxPayResults = WxPayResults() # 创建支付结果对象，并初始化Values为空表
  var data = OrderedTableRef[string, string]()
  wxPayResults.setValues(data)
  result = wxPayResults.init(config, response)
  wxPayApi.reportCostTime(config, url, startTimeStamp, result) # 上报请求花费时间

proc reverse*(wxPayApi: WxPayApi, config: WxPayConfig,
              inputObj: WxPayReverse, timeOut = 6): WxPayResults =
  ## 撤销订单API接口，WxPayReverse中参数out_trade_no和transaction_id必须填写一个,
  ## appid、mchid、spbill_create_ip、nonce_str不需要填入,
  let url = "https://api.mch.weixin.qq.com/secapi/pay/reverse"
  # 检测必填参数
  if not inputObj.isOut_trade_noSet() and not inputObj.isTransaction_idSet():
    raise newException(WxPayException, "撤销订单API接口中，参数out_trade_no和transaction_id必须填写一个！")

  inputObj.setAppid(config.getAppId()) # 公众账号ID
  inputObj.setMch_id(config.getMerchantId()) # 商户号
  inputObj.setNonce_str(wxPayApi.getNonceStr()) # 随机字符串

  inputObj.setSign(config) # 签名
  let xml = inputObj.toXml()

  let startTimeStamp = wxPayApi.getMillisecond() # 请求开始时间
  let response = wxPayApi.postXmlCurl(config, xml, url, true, timeOut)
  var wxPayResults = WxPayResults() # 创建支付结果对象，并初始化Values为空表
  var data = OrderedTableRef[string, string]()
  wxPayResults.setValues(data)
  result = wxPayResults.init(config, response)
  wxPayApi.reportCostTime(config, url, startTimeStamp, result) # 上报请求花费时间

proc bizpayurl*(wxPayApi: WxPayApi, config: WxPayConfig,
                inputObj: WxPayBizPayUrl, timeOut = 6): OrderedTableRef[string, string] =
  ## 生成二维码规则,模式一生成支付二维码,
  ## appid、mchid、spbill_create_ip、nonce_str不需要填入,
  ## 成功时返回，其他抛异常
  if not inputObj.isProduct_idSet():
    raise newException(WxPayException, "生成二维码，缺少必填参数product_id！")

  inputObj.setAppid(config.getAppId()) # 公众账号ID
  inputObj.setMch_id(config.getMerchantId()) # 商户号
  let time = getTime()
  let unixTime = $time.toUnix()
  inputObj.setTime_stamp(unixTime) # 时间戳  
  inputObj.setNonce_str(wxPayApi.getNonceStr()) # 随机字符串

  inputObj.setSign(config) # 签名

  result = inputObj.getValues()

proc shorturl*(wxPayApi: WxPayApi, config: WxPayConfig,
              inputObj: WxPayShortUrl, timeOut = 6): WxPayResults =
  ## 转换短链接,该接口主要用于扫码原生支付模式一中的二维码链接转成短链接(weixin://wxpay/s/XXXXXX)，
  ## 减小二维码数据量，提升扫描速度和精确度。
  ## appid、mchid、spbill_create_ip、nonce_str不需要填入,
  ## 成功时返回，其他抛异常
  let url = "https://api.mch.weixin.qq.com/tools/shorturl"
  # 检测必填参数
  if not inputObj.isLong_urlSet():
    raise newException(WxPayException, "需要转换的URL，签名用原串，传输需URL encode！")

  inputObj.setAppid(config.getAppId()) # 公众账号ID
  inputObj.setMch_id(config.getMerchantId()) # 商户号
  inputObj.setNonce_str(wxPayApi.getNonceStr()) # 随机字符串
  
  inputObj.setSign(config) # 签名
  let xml = inputObj.toXml()
  
  let startTimeStamp = wxPayApi.getMillisecond() # 请求开始时间
  let response = wxPayApi.postXmlCurl(config, xml, url, false, timeOut)
  var wxPayResults = WxPayResults() # 创建支付结果对象，并初始化Values为空表
  var data = OrderedTableRef[string, string]()
  wxPayResults.setValues(data)
  result = wxPayResults.init(config, response)
  wxPayApi.reportCostTime(config, url, startTimeStamp, result) # 上报请求花费时间
