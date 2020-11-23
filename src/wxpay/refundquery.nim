import tables

import database

type WxPayRefundQuery* = ref object of WxPayDataBase
  ## 退款查询输入对象

proc setAppid*(wxPayRefundQuery: WxPayRefundQuery, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayRefundQuery.setData("appid", value)

proc getAppid*(wxPayRefundQuery: WxPayRefundQuery): string =
  ## 获取微信分配的公众账号ID
  result = wxPayRefundQuery.getData("appid")

proc isAppidSet*(wxPayRefundQuery: WxPayRefundQuery): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayRefundQuery.getValues.hasKey("appid")

proc setMch_id*(wxPayRefundQuery: WxPayRefundQuery, value: string) =
  ## 设置微信支付分配的商户号
  wxPayRefundQuery.setData("mch_id", value)

proc getMch_id*(wxPayRefundQuery: WxPayRefundQuery): string =
  ## 获取微信支付分配的商户号
  result = wxPayRefundQuery.getData("mch_id")

proc isMch_idSet*(wxPayRefundQuery: WxPayRefundQuery): bool =
  ## 判断微信支付分配的商户号是否存在
  result = wxPayRefundQuery.getValues.hasKey("mch_id")

proc setDevice_info*(wxPayRefundQuery: WxPayRefundQuery, value: string) =
  ## 设置微信支付分配的终端设备号
  wxPayRefundQuery.setData("device_info", value)

proc getDevice_info*(wxPayRefundQuery: WxPayRefundQuery): string =
  ## 获取微信支付分配的终端设备号
  result = wxPayRefundQuery.getData("device_info")

proc isDevice_infoSet*(wxPayRefundQuery: WxPayRefundQuery): bool =
  ## 判断微信支付分配的终端设备号是否存在
  result = wxPayRefundQuery.getValues.hasKey("device_info")

proc setNonce_str*(wxPayRefundQuery: WxPayRefundQuery, value: string) =
  ## 设置随机字符串，不长于32位。推荐随机数生成算法
  wxPayRefundQuery.setData("nonce_str", value)

proc getNonce_str*(wxPayRefundQuery: WxPayRefundQuery): string =
  ## 获取随机字符串，不长于32位。推荐随机数生成算法
  result = wxPayRefundQuery.getData("nonce_str")

proc isNonce_strSet*(wxPayRefundQuery: WxPayRefundQuery): bool =
  ## 判断随机字符串是否存在，不长于32位。推荐随机数生成算法
  result = wxPayRefundQuery.getValues.hasKey("nonce_str")

proc setTransaction_id*(wxPayRefundQuery: WxPayRefundQuery, value: string) =
  ## 设置微信订单号
  wxPayRefundQuery.setData("transaction_id", value)

proc getTransaction_id*(wxPayRefundQuery: WxPayRefundQuery): string =
  ## 获取微信订单号
  result = wxPayRefundQuery.getData("transaction_id")

proc isTransaction_idSet*(wxPayRefundQuery: WxPayRefundQuery): bool =
  ## 判断微信订单号是否存在
  result = wxPayRefundQuery.getValues.hasKey("transaction_id")

proc setOut_trade_no*(wxPayRefundQuery: WxPayRefundQuery, value: string) =
  ## 设置商户系统内部的订单号
  wxPayRefundQuery.setData("out_trade_no", value)

proc getOut_trade_no*(wxPayRefundQuery: WxPayRefundQuery): string =
  ## 获取商户系统内部的订单号
  result = wxPayRefundQuery.getData("out_trade_no")

proc isOut_trade_noSet*(wxPayRefundQuery: WxPayRefundQuery): bool =
  ## 判断商户系统内部的订单号是否存在
  result = wxPayRefundQuery.getValues.hasKey("out_trade_no")

proc setOut_refund_no*(wxPayRefundQuery: WxPayRefundQuery, value: string) =
  ## 设置商户退款单号
  wxPayRefundQuery.setData("out_refund_no", value)

proc getOut_refund_no*(wxPayRefundQuery: WxPayRefundQuery): string =
  ## 获取商户退款单号
  result = wxPayRefundQuery.getData("out_refund_no")

proc isOut_refund_noSet*(wxPayRefundQuery: WxPayRefundQuery): bool =
  ## 判断商户退款单号是否存在
  result = wxPayRefundQuery.getValues.hasKey("out_refund_no")

proc setRefund_id*(wxPayRefundQuery: WxPayRefundQuery, value: string) =
  ## 设置微信退款单号,refund_id、out_refund_no、out_trade_no、transaction_id四个参数必填一个，
  ## 如果同时存在优先级为：refund_id>out_refund_no>transaction_id>out_trade_no
  wxPayRefundQuery.setData("refund_id", value)

proc getRefund_id*(wxPayRefundQuery: WxPayRefundQuery): string =
  ## 获取微信退款单号,refund_id、out_refund_no、out_trade_no、transaction_id四个参数必填一个，
  ## 如果同时存在优先级为：refund_id>out_refund_no>transaction_id>out_trade_no
  result = wxPayRefundQuery.getData("refund_id")

proc isRefund_idSet*(wxPayRefundQuery: WxPayRefundQuery): bool =
  ## 判断微信退款单号是否存在,refund_id、out_refund_no、out_trade_no、transaction_id四个参数必填一个，
  ## 如果同时存在优先级为：refund_id>out_refund_no>transaction_id>out_trade_no
  result = wxPayRefundQuery.getValues.hasKey("refund_id")