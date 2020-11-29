## 通用功能模块

import strutils, times, random, tables
import xmltree, xmlparser, net, httpclient, md5

import hmac

import ../exception

type
  WxPayData* = OrderedTable[string, string] ## 微信支付数据类型

  WxPayApiType* = enum                      ## 微信支付API类型
    typeMicroPay
    typeOrderQuery
    typeReverse
    typeRefund
    typeRefundQuery
    typeShortUrl
    typeUnifiedOrder
    typeCloseOrder
    typeDownloadBill

func isNumeric*(s: string, enableNaNInf, enableLooseDot = false): bool =
  ## Checks whether the string is numeric.
  ## When the string is an integer, float or exponential, it returns true,
  ## otherwise it returns false.
  ## The `enableNaNInf` value indicates whether the `NaN` and `Inf` values
  ## are valid.
  ## The `enableLooseDot` value indicates whether loose point values such as
  ## `.9` and `9.` are valid. 
  ##
  ## **Note:** The reason that `parseFloat()` is not used to achieve this is its
  ## poor performance.
  let length = s.len
  let sHigh = s.len - 1
  var eLeft, eRight, dot, e, num = false

  if length == 3:
    if (s[0] in {'i', 'I'} and s[1] in {'n', 'N'} and s[2] in {'f', 'F'}) or
       (s[0] in {'n', 'N'} and s[1] in {'a', 'A'} and s[2] in {'n', 'N'}):
      if enableNaNInf:
        return true
      else:
        return false

  if length == 4:
    if (s[0] in {'+', '-'} and s[1] in {'i', 'I'} and s[2] in {'n', 'N'} and s[3] in {'f', 'F'}) or
       (s[0] in {'+', '-'} and s[1] in {'n', 'N'} and s[2] in {'a', 'A'} and s[3] in {'n', 'N'}):
      if enableNaNInf:
        return true
      else:
        return false
  
  for i in countup(0, sHigh):
    case s[i]
    of '+', '-':
      if i == sHigh:
        return false
      if e == false:
        if num:
          return false
        if eLeft:
          return false
        eLeft = true
      else:
        if num:
          return false
        if eRight:
          return false
        eRight = true
    of '.':
      if dot:
        return false
      if not enableLooseDot:
        if num == false:
          return false
        else:
          if i == sHigh:
            return false
          if s[i+1] in {'e', 'E'}:
            return false
      num = false
      dot = true
    of 'e', 'E':
      if i == sHigh:
        return false
      if num or dot:
        if e:
          return false
        num = false
      else:
        return false
      e = true
    of '0'..'9':
      num = true
    of '_':
      if num == false:
        return false
      if dot and num == false:
        return false
      if e and num == false:
        return false
    else:
      return false

  return true

proc getLocalIpAddr*(): string =
  ## 获取本机IP地址
  result = $getPrimaryIPAddr()

proc getCurrentTime*(): string =
  ## 获取被格式化为"yyyyMMddHHmmss"形式的当前时间串
  result = format(getTime(), "yyyyMMddHHmmss")

proc fromXml*(xml: string): WxPayData =
  ## 由xml字符串转换为有序表，返回一个有序表
  var table = WxPayData()
  let xmlnode = parseXml(xml)
  for child in xmlnode:
    if child.kind != xnElement:
      continue
    for item in child:
      table[child.tag] = item.text
  result = table

proc toXml*(table: WxPayData): string =
  ## 输出xml字符
  if table.len <= 0:
    raise newException(WxPayException, "数组数据异常！")
  var xml = "<xml>"
  for key, val in table:
    if isNumeric(val):
      xml.add "<" & key & ">" & val & "</" & key & ">"
    else:
      xml.add "<" & key & "><![CDATA[" & val & "]]></" & key & ">"
  xml.add "</xml>"
  result = xml

proc getNonceStr*(length = 32): string = 
  ## 产生随机字符串，不长于32位
  randomize() # 初始化随机数发生器
  let chars = "abcdefghijklmnopqrstuvwxyz0123456789"
  var str = ""
  var pos = 0
  for i in countup(0, length - 1):
    pos = rand(chars.len - 1)
    str.add chars[pos .. pos]
  result = str

proc getMillisecond*(): string =
  ## 获取毫秒级别的时间戳
  let time = getTime()
  let unixTime = $time.toUnixFloat()
  let seqs = unixTime.split('.')
  result = seqs[0] & seqs[1][0..2]

proc postXmlCurl*(configData:WxPayData,
                  xml, url: string,
                  useCert = false, second = 30): string =
  ## 以post方式提交xml到对应的接口url 
  var client: HttpClient
  var proxy: Proxy
  var proxyHost = configData.getOrDefault("proxy_host", "0.0.0.0")
  var proxyPort = configData.getOrDefault("proxy_port", "0")
  # 如果有配置代理这里就设置代理
  if proxyHost != "0.0.0.0" and proxyPort != "0":
    proxy = newProxy(proxyHost & ":" & proxyPort)
  if useCert:
    var certFilePath = configData.getOrDefault("sslcert_path", "")
    if certFilePath == "":
      raise newException(WxPayException, "apiclient_cert.pem文件路径不能为空！")
    var keyFilePath = configData.getOrDefault("sslkey_path", "")
    if keyFilePath == "":
      raise newException(WxPayException, "apiclient_key.pem文件路径不能为空！")
    var ssl = newContext(certFile = certFilePath, keyFile = keyFilePath)
    client = newHttpClient(proxy = proxy, sslContext = ssl, timeout = second * 1000)
  else:
    client = newHttpClient(proxy = proxy, timeout = second * 1000)
  client.headers = newHttpHeaders({ "Content-Type": "application/xml" }) # 设置header
  let response = client.request(url, httpMethod = HttpPost, body = xml)
  result = response.body

proc toUrlParams*(table: WxPayData): string =
  ## 将数据对象数据格式化成url参数
  var tmp = ""
  for k, v in table:
    if k != "sign" and v != "": # 跳过sign签名和空值键
      tmp.add k & "=" & v & "&"
  tmp.removeSuffix('&')
  result = tmp

proc makeSign*(input: var WxPayData, config: WxPayData,
               needSignType: bool): string =
  ## 使用config参数中指定的签名方式对input参数设置签名并返回签名，
  ## 支持MD5和HMAC-SHA256签名方式，
  ## 当needSignType = true时，使用config参数中配置的sign_type签名方式签名，
  ## 当needSignType = false时，不管配置的是什么签名方式，仅使用md5算法进行签名，
  ## 本函数不覆盖sign成员变量，如要设置签名需要调用setSign方法赋值
  if needSignType:
    input["sign_type"] = config["sign_type"]
  # 签名步骤一按字典序排序参数
  input.sort(system.cmp)
  var s = input.toUrlParams()
  # 签名步骤二在s后加入KEY
  s.add "&key=" & config["key"]
  # 签名步骤三MD5加密或者HMAC-SHA256
  if needSignType:
    if config["sign_type"] == "MD5":
      s = getMD5(s)
    elif config["sign_type"] == "HMAC-SHA256":
      s = toHex(hmac_sha256(config["key"], s))
    else:
      raise newException(WxPayException, "签名类型不支持！")
  else:
    s = getMD5(s)
  # 签名步骤四所有字符转为大写
  result = toUpper(s)

proc setSign*(input: var WxPayData, config: WxPayData): string =
  ## 使用config参数中指定的签名方式对input参数设置签名并返回签名，
  ## 支持MD5和HMAC-SHA256签名方式
  let sign = input.makeSign(config, true)
  input["sign"] = sign
  result = sign

proc makeSign*(input: var WxPayData, config: WxPayData): string =
  ## 根据input参数中已有的签名，自动使用相应的签名方式生成并返回签名，
  ## 支持MD5和HMAC-SHA256签名方式，
  ## 主要用于接口调用返回结果的验证，不适合做请求数据的签名
  # 签名步骤一按字典序排序参数
  input.sort(system.cmp)
  var s = input.toUrlParams()
  # 签名步骤二在s后加入KEY
  s.add "&key=" & config["key"]
  # 签名步骤三MD5加密或者HMAC-SHA256
  if input["sign"].len <= 32:
    # 如果签名小于等于32个,则使用md5验证
    s = getMD5(s)
  else:
    # 用sha256校验
    s = toHex(hmac_sha256(config["key"], s))
  # 签名步骤四所有字符转为大写
  result = toUpper(s)

proc checkSign*(input: var WxPayData, config: WxPayData): bool =
  ## 根据input参数中已有的签名，自动使用相应的签名方式检测接口调用结果的签名，
  ## 支持MD5和HMAC-SHA256签名方式
  if not input.hasKey("sign"):
    raise newException(WxPayException, "签名错误！")
  let sign = input.makeSign(config)
  if input["sign"] == sign:
    # 签名正确
    result = true
  else:
    raise newException(WxPayException, "签名错误！")

proc initConfig*(config: WxPayData,
                 apiType: WxPayApiType): WxPayData =
  ## 根据用户输入的数据创建并初始化配置
  var configData = WxPayData()
  case apiType
  of typeMicroPay: # 检查被扫支付的配置
    if not config.hasKey("appid") or config["appid"] == "":
      raise newException(WxPayException, "被扫支付配置参数中缺少必填参数：公众号appid ！")
    if not config.hasKey("mch_id") or config["mch_id"] == "":
      raise newException(WxPayException, "被扫支付配置参数中缺少必填参数：商户号mch_id ！")
    if not config.hasKey("key") or config["key"] == "":
      raise newException(WxPayException, "被扫支付配置参数中缺少必填参数：商户支付密钥key ！")
  of typeDownloadBill: # 检查下载对账单的配置
    if not config.hasKey("appid") or config["appid"] == "":
      raise newException(WxPayException, "下载对账单配置参数中缺少必填参数：公众号appid ！")
    if not config.hasKey("mch_id") or config["mch_id"] == "":
      raise newException(WxPayException, "下载对账单配置参数中缺少必填参数：商户号mch_id ！")
    if not config.hasKey("key") or config["key"] == "":
      raise newException(WxPayException, "下载对账单配置参数中缺少必填参数：商户支付密钥key ！")
  of typeOrderQuery: # 检查订单查询的配置
    if not config.hasKey("appid") or config["appid"] == "":
      raise newException(WxPayException, "订单查询配置参数中缺少必填参数：公众号appid ！")
    if not config.hasKey("mch_id") or config["mch_id"] == "":
      raise newException(WxPayException, "订单查询配置参数中缺少必填参数：商户号mch_id ！")
    if not config.hasKey("key") or config["key"] == "":
      raise newException(WxPayException, "订单查询配置参数中缺少必填参数：商户支付密钥key ！")
  of typeReverse: # 检查撤销订单的配置
    if not config.hasKey("appid") or config["appid"] == "":
      raise newException(WxPayException, "撤销订单配置参数中缺少必填参数：公众号appid ！")
    if not config.hasKey("mch_id") or config["mch_id"] == "":
      raise newException(WxPayException, "撤销订单配置参数中缺少必填参数：商户号mch_id ！")
    if not config.hasKey("key") or config["key"] == "":
      raise newException(WxPayException, "撤销订单配置参数中缺少必填参数：商户支付密钥key ！")
  of typeRefund: # 检查退款申请的配置
    if not config.hasKey("appid") or config["appid"] == "":
      raise newException(WxPayException, "退款申请配置参数中缺少必填参数：公众号appid ！")
    if not config.hasKey("mch_id") or config["mch_id"] == "":
      raise newException(WxPayException, "退款申请配置参数中缺少必填参数：商户号mch_id ！")
    if not config.hasKey("key") or config["key"] == "":
      raise newException(WxPayException, "退款申请配置参数中缺少必填参数：商户支付密钥key ！")
  of typeRefundQuery: # 检查退款查询的配置
    if not config.hasKey("appid") or config["appid"] == "":
      raise newException(WxPayException, "退款查询配置参数中缺少必填参数：公众号appid ！")
    if not config.hasKey("mch_id") or config["mch_id"] == "":
      raise newException(WxPayException, "退款查询配置参数中缺少必填参数：商户号mch_id ！")
    if not config.hasKey("key") or config["key"] == "":
      raise newException(WxPayException, "退款查询配置参数中缺少必填参数：商户支付密钥key ！")
  of typeShortUrl: # 检查转换短链接的配置
    if not config.hasKey("appid") or config["appid"] == "":
      raise newException(WxPayException, "转换短链接配置参数中缺少必填参数：公众号appid ！")
    if not config.hasKey("mch_id") or config["mch_id"] == "":
      raise newException(WxPayException, "转换短链接配置参数中缺少必填参数：商户号mch_id ！")
    if not config.hasKey("key") or config["key"] == "":
      raise newException(WxPayException, "转换短链接配置参数中缺少必填参数：商户支付密钥key ！")
  of typeUnifiedOrder: # 检查统一下单的配置
    if not config.hasKey("appid") or config["appid"] == "":
      raise newException(WxPayException, "统一下单配置参数中缺少必填参数：公众号appid ！")
    if not config.hasKey("mch_id") or config["mch_id"] == "":
      raise newException(WxPayException, "统一下单配置参数中缺少必填参数：商户号mch_id ！")
    if not config.hasKey("key") or config["key"] == "":
      raise newException(WxPayException, "统一下单配置参数中缺少必填参数：商户支付密钥key ！")
  of typeCloseOrder: # 检查关闭订单的配置
    if not config.hasKey("appid") or config["appid"] == "":
      raise newException(WxPayException, "关闭订单配置参数中缺少必填参数：公众号appid ！")
    if not config.hasKey("mch_id") or config["mch_id"] == "":
      raise newException(WxPayException, "关闭订单配置参数中缺少必填参数：商户号mch_id ！")
    if not config.hasKey("key") or config["key"] == "":
      raise newException(WxPayException, "关闭订单配置参数中缺少必填参数：商户支付密钥key ！")
  # 根据情况初始化全部配置参数
  configData["appid"] = config.getOrDefault("appid", "")
  configData["mch_id"] = config.getOrDefault("mch_id", "")
  configData["key"] = config.getOrDefault("key", "")
  configData["appsecret"] = config.getOrDefault("appsecret", "")
  configData["sign_type"] = config.getOrDefault("sign_type", "HMAC-SHA256")
  configData["report_level"] = config.getOrDefault("report_level", "1")
  configData["notify_url"] = config.getOrDefault("notify_url", "")
  configData["proxy_host"] = config.getOrDefault("proxy_host", "0.0.0.0")
  configData["proxy_port"] = config.getOrDefault("proxy_port", "0")
  configData["sslcert_path"] = config.getOrDefault("sslcert_path", "")
  configData["sslkey_path"] = config.getOrDefault("sslkey_path", "")
  result = configData 

proc checkResults*(configData: WxPayData,
                   xml: string, enableCheckSign = true): WxPayData =
  ## 检测接口调用返回的xml字符串是否合法，并且将其转换为有序表返回
  var ret = fromXml(xml)
  if enableCheckSign:
    discard ret.checkSign(configData)
  # 失败则直接返回失败
  if ret["return_code"] != "SUCCESS":
    for key, value in ret:
      # 除了return_code和return_msg之外其他的参数存在，则报错
      if key != "return_code" and key != "return_msg":
        raise newException(WxPayException, "输入数据存在异常！")
  result = ret
