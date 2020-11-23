import tables

import database

type WxPayJsApiPay* = ref object of WxPayDataBase
  ## 提交JSAPI输入对象

proc setAppid*(wxPayJsApiPay: WxPayJsApiPay, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayJsApiPay.setData("appId", value)

proc getAppid*(wxPayJsApiPay: WxPayJsApiPay): string =
  ## 获取微信分配的公众账号ID
  result = wxPayJsApiPay.getData("appId")

proc isAppidSet*(wxPayJsApiPay: WxPayJsApiPay): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayJsApiPay.getValues.hasKey("appId")

proc setTimeStamp*(wxPayJsApiPay: WxPayJsApiPay, value: string) =
  ## 设置支付时间戳
  wxPayJsApiPay.setData("timeStamp", value)

proc getTimeStamp*(wxPayJsApiPay: WxPayJsApiPay): string =
  ## 获取支付时间戳
  result = wxPayJsApiPay.getData("timeStamp")

proc isTimeStampSet*(wxPayJsApiPay: WxPayJsApiPay): bool =
  ## 判断支付时间戳是否存在
  wxPayJsApiPay.getValues.hasKey("timeStamp")

proc setNonceStr*(wxPayJsApiPay: WxPayJsApiPay, value: string) =
  ## 设置随机字符串
  wxPayJsApiPay.setData("nonceStr", value)

proc getReturn_code*(wxPayJsApiPay: WxPayJsApiPay): string =
  ## 获取notify随机字符串
  result = wxPayJsApiPay.getData("nonceStr")

proc isReturn_codeSet*(wxPayJsApiPay: WxPayJsApiPay): bool =
  ## 判断随机字符串是否存在
  wxPayJsApiPay.getValues.hasKey("nonceStr")

proc setPackage*(wxPayJsApiPay: WxPayJsApiPay, value: string) =
  ## 设置订单详情扩展字符串
  wxPayJsApiPay.setData("package", value)

proc getPackage*(wxPayJsApiPay: WxPayJsApiPay): string =
  ## 获取订单详情扩展字符串
  result = wxPayJsApiPay.getData("package")

proc isPackageSet*(wxPayJsApiPay: WxPayJsApiPay): bool =
  ## 判断订单详情扩展字符串是否存在
  wxPayJsApiPay.getValues.hasKey("package")

proc setSignType*(wxPayJsApiPay: WxPayJsApiPay, value: string) =
  ## 设置签名方式
  wxPayJsApiPay.setData("signType", value)

proc getSignType*(wxPayJsApiPay: WxPayJsApiPay): string =
  ## 获取签名方式
  result = wxPayJsApiPay.getData("signType")

proc isSignTypeSet*(wxPayJsApiPay: WxPayJsApiPay): bool =
  ## 判断签名方式是否存在
  wxPayJsApiPay.getValues.hasKey("signType")

proc setPaySign*(wxPayJsApiPay: WxPayJsApiPay, value: string) =
  ## 设置签名
  wxPayJsApiPay.setData("paySign", value)

proc getPaySign*(wxPayJsApiPay: WxPayJsApiPay): string =
  ## 获取签名
  result = wxPayJsApiPay.getData("paySign")

proc isPaySignSet*(wxPayJsApiPay: WxPayJsApiPay): bool =
  ## 判断签名是否存在
  wxPayJsApiPay.getValues.hasKey("paySign")