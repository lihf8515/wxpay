import tables

import database

type WxPayReverse* = ref object of WxPayDataBase
  ## 撤销输入对象

proc setAppid*(wxPayReverse: WxPayReverse, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayReverse.setData("appid", value)

proc getAppid*(wxPayReverse: WxPayReverse): string =
  ## 获取微信分配的公众账号ID
  result = wxPayReverse.getData("appid")

proc isAppidSet*(wxPayReverse: WxPayReverse): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayReverse.getValues.hasKey("appid")

proc setMch_id*(wxPayReverse: WxPayReverse, value: string) =
  ## 设置微信支付分配的商户号
  wxPayReverse.setData("mch_id", value)

proc getMch_id*(wxPayReverse: WxPayReverse): string =
  ## 获取微信支付分配的商户号
  result = wxPayReverse.getData("mch_id")

proc isMch_idSet*(wxPayReverse: WxPayReverse): bool =
  ## 判断微信支付分配的商户号是否存在
  result = wxPayReverse.getValues.hasKey("mch_id")

proc setTransaction_id*(wxPayReverse: WxPayReverse, value: string) =
  ## 设置微信的订单号，优先使用
  wxPayReverse.setData("transaction_id", value)

proc getTransaction_id*(wxPayReverse: WxPayReverse): string =
  ## 获取微信的订单号，优先使用
  result = wxPayReverse.getData("transaction_id")

proc isTransaction_idSet*(wxPayReverse: WxPayReverse): bool =
  ## 判断微信的订单号是否存在
  result = wxPayReverse.getValues.hasKey("transaction_id")

proc setOut_trade_no*(wxPayReverse: WxPayReverse, value: string) =
  ## 设置商户系统内部的订单号,transaction_id、out_trade_no二选一，
  ## 如果同时存在优先级：transaction_id > out_trade_no
  wxPayReverse.setData("out_trade_no", value)

proc getOut_trade_no*(wxPayReverse: WxPayReverse): string =
  ## 获取商户系统内部的订单号,transaction_id、out_trade_no二选一，
  ## 如果同时存在优先级：transaction_id > out_trade_no
  result = wxPayReverse.getData("out_trade_no")

proc isOut_trade_noSet*(wxPayReverse: WxPayReverse): bool =
  ## 判断商户系统内部的订单号是否存在,transaction_id、out_trade_no二选一，
  ## 如果同时存在优先级：transaction_id > out_trade_no
  result = wxPayReverse.getValues.hasKey("out_trade_no")

proc setNonce_str*(wxPayReverse: WxPayReverse, value: string) =
  ## 设置随机字符串，不长于32位。推荐随机数生成算法
  wxPayReverse.setData("nonce_str", value)

proc getNonce_str*(wxPayReverse: WxPayReverse): string =
  ## 获取随机字符串，不长于32位。推荐随机数生成算法
  result = wxPayReverse.getData("nonce_str")

proc isNonce_strSet*(wxPayReverse: WxPayReverse): bool =
  ## 判断随机字符串是否存在，不长于32位。推荐随机数生成算法
  result = wxPayReverse.getValues.hasKey("nonce_str")
