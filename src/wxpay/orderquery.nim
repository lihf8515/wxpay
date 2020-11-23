import tables

import database
export database

type
  WxPayOrderQuery* = ref object of WxPayDataBase
  ##订单查询输入对象

proc setAppid*(wxPayOrderQuery: WxPayOrderQuery, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayOrderQuery.setData("appid", value)

proc getAppid*(wxPayOrderQuery: WxPayOrderQuery): string =
  ## 获取微信分配的公众账号ID
  result = wxPayOrderQuery.getData("appid")

proc isAppidSet*(wxPayOrderQuery: WxPayOrderQuery): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayOrderQuery.getValues.hasKey("appid")

proc setMch_id*(wxPayOrderQuery: WxPayOrderQuery, value: string) =
  ## 设置微信支付分配的商户号
  wxPayOrderQuery.setData("mch_id", value)

proc getMch_id*(wxPayOrderQuery: WxPayOrderQuery): string =
  ## 获取微信支付分配的商户号
  result = wxPayOrderQuery.getData("mch_id")

proc isMch_idSet*(wxPayOrderQuery: WxPayOrderQuery): bool =
  ## 判断微信支付分配的商户号是否存在
  result = wxPayOrderQuery.getValues.hasKey("mch_id")

proc setTransaction_id*(wxPayOrderQuery: WxPayOrderQuery, value: string) =
  ## 设置微信的订单号，优先使用
  wxPayOrderQuery.setData("transaction_id", value)

proc getTransaction_id*(wxPayOrderQuery: WxPayOrderQuery): string =
  ## 获取微信的订单号，优先使用
  result = wxPayOrderQuery.getData("transaction_id")

proc isTransaction_idSet*(wxPayOrderQuery: WxPayOrderQuery): bool =
  ## 判断微信的订单号是否存在
  result = wxPayOrderQuery.getValues.hasKey("transaction_id")

proc setOut_trade_no*(wxPayOrderQuery: WxPayOrderQuery, value: string) =
  ## 设置商户系统内部的订单号，当没提供transaction_id时需要传这个
  wxPayOrderQuery.setData("out_trade_no", value)

proc getOut_trade_no*(wxPayOrderQuery: WxPayOrderQuery): string =
  ## 获取商户系统内部的订单号，当没提供transaction_id时需要传这个
  result = wxPayOrderQuery.getData("out_trade_no")

proc isOut_trade_noSet*(wxPayOrderQuery: WxPayOrderQuery): bool =
  ## 判断商户系统内部的订单号是否存在，当没提供transaction_id时需要传这个
  result = wxPayOrderQuery.getValues.hasKey("out_trade_no")

proc setNonce_str*(wxPayOrderQuery: WxPayOrderQuery, value: string) =
  ## 设置随机字符串，不长于32位。推荐随机数生成算法
  wxPayOrderQuery.setData("nonce_str", value)

proc getNonce_str*(wxPayOrderQuery: WxPayOrderQuery): string =
  ## 获取随机字符串，不长于32位。推荐随机数生成算法
  result = wxPayOrderQuery.getData("nonce_str")

proc isNonce_strSet*(wxPayOrderQuery: WxPayOrderQuery): bool =
  ## 判断随机字符串是否存在，不长于32位。推荐随机数生成算法
  result = wxPayOrderQuery.getValues.hasKey("nonce_str")
