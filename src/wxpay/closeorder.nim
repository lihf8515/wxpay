import tables

import database

type WxPayCloseOrder* = ref object of WxPayDataBase
  ## 关闭订单输入对象

proc setAppid*(wxPayCloseOrder: WxPayCloseOrder, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayCloseOrder.setData("appid", value)

proc getAppid*(wxPayCloseOrder: WxPayCloseOrder): string =
  ## 获取微信分配的公众账号ID
  result = wxPayCloseOrder.getData("appid")

proc isAppidSet*(wxPayCloseOrder: WxPayCloseOrder): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayCloseOrder.getValues.hasKey("appid")

proc setMch_id*(wxPayCloseOrder: WxPayCloseOrder, value: string) =
  ## 设置微信支付分配的商户号
  wxPayCloseOrder.setData("mch_id", value)

proc getMch_id*(wxPayCloseOrder: WxPayCloseOrder): string =
  ## 获取微信支付分配的商户号
  result = wxPayCloseOrder.getData("mch_id")

proc isMch_idSet*(wxPayCloseOrder: WxPayCloseOrder): bool =
  ## 判断微信支付分配的商户号是否存在
  result = wxPayCloseOrder.getValues.hasKey("mch_id")

proc setOut_trade_no*(wxPayCloseOrder: WxPayCloseOrder, value: string) =
  ## 设置商户系统内部的订单号
  wxPayCloseOrder.setData("out_trade_no", value)

proc getOut_trade_no*(wxPayCloseOrder: WxPayCloseOrder): string =
  ## 获取商户系统内部的订单号
  result = wxPayCloseOrder.getData("out_trade_no")

proc isOut_trade_noSet*(wxPayCloseOrder: WxPayCloseOrder): bool =
  ## 判断商户系统内部的订单号是否存在
  result = wxPayCloseOrder.getValues.hasKey("out_trade_no")

proc setNonce_str*(wxPayCloseOrder: WxPayCloseOrder, value: string) =
  ## 设置商户系统内部的订单号,32个字符内、可包含字母, 其他说明见商户订单号
  wxPayCloseOrder.setData("nonce_str", value)

proc getNonce_str*(wxPayCloseOrder: WxPayCloseOrder): string =
  ## 获取商户系统内部的订单号,32个字符内、可包含字母, 其他说明见商户订单号
  result = wxPayCloseOrder.getData("nonce_str")

proc isNonce_strSet*(wxPayCloseOrder: WxPayCloseOrder): bool =
  ## 判断商户系统内部的订单号是否存在,32个字符内、可包含字母, 其他说明见商户订单号
  result = wxPayCloseOrder.getValues.hasKey("nonce_str")
