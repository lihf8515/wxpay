import tables

import database

type WxPayShortUrl* = ref object of WxPayDataBase
  ## 短链转换输入对象

proc setAppid*(wxPayShortUrl: WxPayShortUrl, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayShortUrl.setData("appid", value)

proc getAppid*(wxPayShortUrl: WxPayShortUrl): string =
  ## 获取微信分配的公众账号ID
  result = wxPayShortUrl.getData("appid")

proc isAppidSet*(wxPayShortUrl: WxPayShortUrl): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayShortUrl.getValues.hasKey("appid")

proc setMch_id*(wxPayShortUrl: WxPayShortUrl, value: string) =
  ## 设置微信支付分配的商户号
  wxPayShortUrl.setData("mch_id", value)

proc getMch_id*(wxPayShortUrl: WxPayShortUrl): string =
  ## 获取微信支付分配的商户号
  result = wxPayShortUrl.getData("mch_id")

proc isMch_idSet*(wxPayShortUrl: WxPayShortUrl): bool =
  ## 判断微信支付分配的商户号是否存在
  result = wxPayShortUrl.getValues.hasKey("mch_id")

proc setLong_url*(wxPayShortUrl: WxPayShortUrl, value: string) =
  ## 设置需要转换的URL，签名用原串，传输需URL encode
  wxPayShortUrl.setData("long_url", value)

proc getLong_url*(wxPayShortUrl: WxPayShortUrl): string =
  ## 获取需要转换的URL，签名用原串，传输需URL encode
  result = wxPayShortUrl.getData("long_url")

proc isLong_urlSet*(wxPayShortUrl: WxPayShortUrl): bool =
  ## 判断需要转换的URL是否存在，签名用原串，传输需URL encode
  result = wxPayShortUrl.getValues.hasKey("long_url")

proc setNonce_str*(wxPayShortUrl: WxPayShortUrl, value: string) =
  ## 设置随机字符串，不长于32位。推荐随机数生成算法
  wxPayShortUrl.setData("nonce_str", value)

proc getNonce_str*(wxPayShortUrl: WxPayShortUrl): string =
  ## 获取随机字符串，不长于32位。推荐随机数生成算法
  result = wxPayShortUrl.getData("nonce_str")

proc isNonce_strSet*(wxPayShortUrl: WxPayShortUrl): bool =
  ## 判断随机字符串是否存在，不长于32位。推荐随机数生成算法
  result = wxPayShortUrl.getValues.hasKey("nonce_str")