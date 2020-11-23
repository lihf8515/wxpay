import tables

type WxPayConfig* = ref object of RootObj
  ## 账号配置信息类
  values: OrderedTableRef[string, string] ## 配置信息，用有序表存储

method getValues*(cfg: WxPayConfig): OrderedTableRef[string, string]
    {.base.} =
  ## 获取数据对象的数据，返回一个有序表
  result = cfg.values

method setValues*(cfg: WxPayConfig,
                  values: OrderedTableRef[string, string]) {.base.} =
  ## 设置数据对象数据
  cfg.values = values

method getData*(cfg: WxPayConfig, key: string): string {.base.} =
  ## 获取数据对象数据指定KEY的值
  result = cfg.values[key]

method setData*(cfg: WxPayConfig, key, value: string) {.base.} =
  ## 设置数据对象数据指定KEY的值
  if cfg.values == nil:
    var t = OrderedTableRef[string, string]()
    t[key] = value
    cfg.values = t
  else:
    cfg.values[key] = value

# ===================配置信息：您自己申请的商户信息和微信公众号信息===================
method setAppId*(cfg: WxPayConfig, value = "") {.base.} =
  ## 设置APPID：绑定支付的APPID（必须配置，开户邮件中可查看）
  cfg.setData("appid", value)

method getAppId*(cfg: WxPayConfig): string {.base.} =
  ## 获取APPID：绑定支付的APPID（必须配置，开户邮件中可查看）
  if cfg.getValues.hasKey("appid"):
    result = cfg.getData("appid")
  else:
    result = ""

method setMerchantId*(cfg: WxPayConfig, value = "") {.base.} =
  ## 设置MCHID：商户号（必须配置，开户邮件中可查看）
  cfg.setData("mch_id", value)

method getMerchantId*(cfg: WxPayConfig): string {.base.} =
  ## 获取MCHID：商户号（必须配置，开户邮件中可查看）
  if cfg.getValues.hasKey("mch_id"):
    result = cfg.getData("mch_id")
  else:
    result = ""
  
# ===================支付相关配置：支付成功回调地址/签名方式===================
method setNotifyUrl*(cfg: WxPayConfig, value = "") {.base.} =
  ## 设置支付回调url
  cfg.setData("notify_url", value)

method getNotifyUrl*(cfg: WxPayConfig): string {.base.} =
  ## 获取支付回调url
  if cfg.getValues.hasKey("notify_url"):
    result = cfg.getData("notify_url")
  else:
    result = ""

method setSignType*(cfg: WxPayConfig, value = "HMAC-SHA256") {.base.} =
  ## 设置签名和验证签名方式， 支持md5和sha256方式
  cfg.setData("sign_type", value)

method getSignType*(cfg: WxPayConfig): string {.base.} =
  ## 获取签名和验证签名方式， 支持md5和sha256方式
  if cfg.getValues.hasKey("sign_type"):
    result = cfg.getData("sign_type")
  else:
    result = "HMAC-SHA256"

# ===================curl代理设置===================
method setProxy*(cfg: WxPayConfig, proxyHost = "0.0.0.0", proxyPort = "0") {.base.} =
  ## 设置代理机器，只有需要代理的时候才设置，不需要代理，请设置为0.0.0.0和0，
  ## 本例程通过curl使用HTTP POST方法，此处可修改代理服务器，
  ## 默认CURL_PROXY_HOST=0.0.0.0和CURL_PROXY_PORT=0，此时不开启代理（如有需要才设置）
  cfg.setData("proxy_host", proxyHost)
  cfg.setData("proxy_port", proxyPort)

method getProxy*(cfg: WxPayConfig, proxyHost, proxyPort: var string) {.base.} =
  ## 获取设置代理机器，只有需要代理的时候才设置，不需要代理，请设置为0.0.0.0和0，
  ## 本例程通过curl使用HTTP POST方法，此处可修改代理服务器，
  ## 默认CURL_PROXY_HOST=0.0.0.0和CURL_PROXY_PORT=0，此时不开启代理（如有需要才设置）
  if cfg.getValues.hasKey("proxy_host"):
    proxyHost = cfg.getData("proxy_host")
  else:
    proxyHost = "0.0.0.0"
  
  if cfg.getValues.hasKey("proxy_port"):
    proxyPort = cfg.getData("proxy_port")
  else:
    proxyPort = "0"

# ===================上报信息配置===================
method setReportLevel*(cfg: WxPayConfig, value = "1") {.base.} =
  ## 设置接口调用上报等级，默认仅错误上报（注意：上报超时间为【1s】，上报无论成败【永不抛出异常】，
  ## 不会影响接口调用流程），开启上报之后，方便微信监控请求调用的质量，建议至少开启错误上报。
  ## 上报等级，0.关闭上报; 1.仅错误出错上报; 2.全量上报
  cfg.setData("report_level", value)

method getReportLevel*(cfg: WxPayConfig): string {.base.} =
  ## 获取接口调用上报等级，默认仅错误上报（注意：上报超时间为【1s】，上报无论成败【永不抛出异常】，
  ## 不会影响接口调用流程），开启上报之后，方便微信监控请求调用的质量，建议至少开启错误上报。
  ## 上报等级，0.关闭上报; 1.仅错误出错上报; 2.全量上报
  if cfg.getValues.hasKey("report_level"):
    result = cfg.getData("report_level")
  else:
    result = "1"

#===================商户密钥信息-需要业务方继承===================
method setKey*(cfg: WxPayConfig, value = "") {.base.} =
  ## 设置KEY：商户支付密钥，参考开户邮件设置（必须配置，登录商户平台自行设置）,请妥善保管，避免密钥泄露，
  ## 设置地址：https://pay.weixin.qq.com/index.php/account/api_cert
  cfg.setData("key", value)

method getKey*(cfg: WxPayConfig): string {.base.} =
  ## 获取KEY：商户支付密钥，参考开户邮件设置（必须配置，登录商户平台自行设置）,请妥善保管，避免密钥泄露，
  ## 设置地址：https://pay.weixin.qq.com/index.php/account/api_cert
  if cfg.getValues.hasKey("key"):
    result = cfg.getData("key")
  else:
    result = ""

method setAppSecret*(cfg: WxPayConfig, value = "") {.base.} =
  ## 设置APPSECRET：公众帐号secert（仅JSAPI支付的时候需要配置， 登录公众平台，进入开发者中心可设置），请妥善保管，避免密钥泄露，
  ## 获取地址：https://mp.weixin.qq.com/advanced/advanced?action=dev&t=advanced/dev&token=2005451881&lang=zh_CN
  cfg.setData("appsecret", value)

method getAppSecret*(cfg: WxPayConfig): string {.base.} =
  ## 获取APPSECRET：公众帐号secert（仅JSAPI支付的时候需要配置， 登录公众平台，进入开发者中心可设置），请妥善保管，避免密钥泄露，
  ## 获取地址：https://mp.weixin.qq.com/advanced/advanced?action=dev&t=advanced/dev&token=2005451881&lang=zh_CN
  if cfg.getValues.hasKey("appsecret"):
    result = cfg.getData("appsecret")
  else:
    result = ""

#===================证书路径设置-需要业务方继承===================
method setSSLCertPath*(cfg: WxPayConfig,
                       sslCertPath = "../cert/apiclient_cert.pem",
                       sslKeyPath = "../cert/apiclient_key.pem") {.base.} =
  ## 设置商户证书路径，
  ## 证书路径,注意应该填写绝对路径（仅退款、撤销订单时需要，可登录商户平台下载，
  ## API证书下载地址：https://pay.weixin.qq.com/index.php/account/api_cert，下载之前需要安装商户操作证书），
  ## 注意:
  ## 1.证书文件不能放在web服务器虚拟目录，应放在有访问权限控制的目录中，防止被他人下载；
  ## 2.建议将证书文件名改为复杂且不容易猜测的文件名；
  ## 3.商户服务器要做好病毒和木马防护工作，不被非法侵入者窃取证书文件。
  cfg.setData("sslcert_path", sslCertPath)
  cfg.setData("sslkey_path", sslKeyPath)

method getSSLCertPath*(cfg: WxPayConfig, sslCertPath, sslKeyPath: var string) {.base.} =
  ## 获取商户证书路径，
  ## 证书路径,注意应该填写绝对路径（仅退款、撤销订单时需要，可登录商户平台下载，
  ## API证书下载地址：https://pay.weixin.qq.com/index.php/account/api_cert，下载之前需要安装商户操作证书），
  ## 注意:
  ## 1.证书文件不能放在web服务器虚拟目录，应放在有访问权限控制的目录中，防止被他人下载；
  ## 2.建议将证书文件名改为复杂且不容易猜测的文件名；
  ## 3.商户服务器要做好病毒和木马防护工作，不被非法侵入者窃取证书文件。
  if cfg.getValues.hasKey("sslcert_path"):
    sslCertPath = cfg.getData("sslcert_path")
  else:
    sslCertPath = "../cert/apiclient_cert.pem"
  
  if cfg.getValues.hasKey("sslkey_path"):
    sslKeyPath = cfg.getData("sslkey_path")
  else:
    sslKeyPath = "../cert/apiclient_key.pem"

