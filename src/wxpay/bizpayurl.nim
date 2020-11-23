import tables

import databasemd5

type WxPayBizPayUrl* = ref object of WxPayDataBaseSignMd5
  ## 扫码支付模式一生成二维码参数

proc setAppid*(wxPayBizPayUrl: WxPayBizPayUrl, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayBizPayUrl.setData("appid", value)

proc getAppid*(wxPayBizPayUrl: WxPayBizPayUrl): string =
  ## 获取微信分配的公众账号ID
  result = wxPayBizPayUrl.getData("appid")

proc isAppidSet*(wxPayBizPayUrl: WxPayBizPayUrl): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayBizPayUrl.getValues.hasKey("appid")

proc setMch_id*(wxPayBizPayUrl: WxPayBizPayUrl, value: string) =
  ## 设置微信支付分配的商户号
  wxPayBizPayUrl.setData("mch_id", value)

proc getMch_id*(wxPayBizPayUrl: WxPayBizPayUrl): string =
  ## 获取微信支付分配的商户号
  result = wxPayBizPayUrl.getData("mch_id")

proc isMch_idSet*(wxPayBizPayUrl: WxPayBizPayUrl): bool =
  ## 判断微信支付分配的商户号是否存在
  result = wxPayBizPayUrl.getValues.hasKey("mch_id")

proc setTime_stamp*(wxPayBizPayUrl: WxPayBizPayUrl, value: string) =
  ## 设置支付时间戳
  wxPayBizPayUrl.setData("time_stamp", value)

proc getTime_stamp*(wxPayBizPayUrl: WxPayBizPayUrl): string =
  ## 获取支付时间戳
  result = wxPayBizPayUrl.getData("time_stamp")

proc isTime_stampSet*(wxPayBizPayUrl: WxPayBizPayUrl): bool =
  ## 判断支付时间戳是否存在
  result = wxPayBizPayUrl.getValues.hasKey("time_stamp")

proc setNonce_str*(wxPayBizPayUrl: WxPayBizPayUrl, value: string) =
  ## 设置随机字符串
  wxPayBizPayUrl.setData("nonce_str", value)

proc getNonce_str*(wxPayBizPayUrl: WxPayBizPayUrl): string =
  ## 获取随机字符串
  result = wxPayBizPayUrl.getData("nonce_str")

proc isNonce_strSet*(wxPayBizPayUrl: WxPayBizPayUrl): bool =
  ## 判断随机字符串是否存在
  result = wxPayBizPayUrl.getValues.hasKey("nonce_str")

proc setProduct_id*(wxPayBizPayUrl: WxPayBizPayUrl, value: string) =
  ## 设置商品ID
  wxPayBizPayUrl.setData("product_id", value)

proc getProduct_id*(wxPayBizPayUrl: WxPayBizPayUrl): string =
  ## 获取商品ID
  result = wxPayBizPayUrl.getData("product_id")

proc isProduct_idSet*(wxPayBizPayUrl: WxPayBizPayUrl): bool =
  ## 判断商品ID是否存在
  result = wxPayBizPayUrl.getValues.hasKey("product_id")
