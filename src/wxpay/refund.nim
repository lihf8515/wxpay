import  tables

import database

type WxPayRefund* = ref object of WxPayDataBase
  ## 提交退款输入对象
  
proc setAppid*(wxPayRefund: WxPayRefund, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayRefund.setData("appid", value) 

proc getAppid*(wxPayRefund: WxPayRefund): string =
  ## 获取微信分配的公众账号ID
  result = wxPayRefund.getData("appid")

proc isAppidSet*(wxPayRefund: WxPayRefund): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayRefund.getValues.hasKey("appid")

proc setMch_id*(wxPayRefund: WxPayRefund, value: string) =
  ## 设置微信支付分配的商户号
  wxPayRefund.setData("mch_id", value)

proc getMch_id*(wxPayRefund: WxPayRefund): string =
  ## 获取微信支付分配的商户号
  result = wxPayRefund.getData("mch_id")

proc isMch_idSet*(wxPayRefund: WxPayRefund): bool =
  ## 判断微信支付分配的商户号是否存在
  result = wxPayRefund.getValues.hasKey("mch_id")

proc setDevice_info*(wxPayRefund: WxPayRefund, value: string) =
  ## 设置微信支付分配的终端设备号，商户自定义
  wxPayRefund.setData("device_info", value)

proc getDevice_info*(wxPayRefund: WxPayRefund): string =
  ## 获取微信支付分配的终端设备号，商户自定义
  result = wxPayRefund.getData("device_info")

proc isDevice_infoSet*(wxPayRefund: WxPayRefund): bool =
  ## 判断微信支付分配的终端设备号是否存在，商户自定义
  result = wxPayRefund.getValues.hasKey("device_info")

proc setNonce_str*(wxPayRefund: WxPayRefund, value: string) =
  ## 设置随机字符串，不长于32位。推荐随机数生成算法
  wxPayRefund.setData("nonce_str", value)

proc getNonce_str*(wxPayRefund: WxPayRefund): string =
  ## 获取随机字符串，不长于32位。推荐随机数生成算法
  result = wxPayRefund.getData("nonce_str")

proc isNonce_strSet*(wxPayRefund: WxPayRefund): bool =
  ## 判断随机字符串是否存在，不长于32位。推荐随机数生成算法
  result = wxPayRefund.getValues.hasKey("nonce_str")

proc setTransaction_id*(wxPayRefund: WxPayRefund, value: string) =
  ## 设置微信的订单号，优先使用
  wxPayRefund.setData("transaction_id", value)

proc getTransaction_id*(wxPayRefund: WxPayRefund): string =
  ## 获取微信的订单号，优先使用
  result = wxPayRefund.getData("transaction_id")

proc isTransaction_idSet*(wxPayRefund: WxPayRefund): bool =
  ## 判断微信的订单号是否存在
  result = wxPayRefund.getValues.hasKey("transaction_id")

proc setOut_trade_no*(wxPayRefund: WxPayRefund, value: string) =
  ## 设置商户系统内部的订单号,transaction_id、out_trade_no二选一，
  ## 如果同时存在优先级：transaction_id > out_trade_no
  wxPayRefund.setData("out_trade_no", value)

proc getOut_trade_no*(wxPayRefund: WxPayRefund): string =
  ## 获取商户系统内部的订单号,transaction_id、out_trade_no二选一，
  ## 如果同时存在优先级：transaction_id > out_trade_no
  result = wxPayRefund.getData("out_trade_no")

proc isOut_trade_noSet*(wxPayRefund: WxPayRefund): bool =
  ## 判断商户系统内部的订单号是否存在,transaction_id、out_trade_no二选一，
  ## 如果同时存在优先级：transaction_id > out_trade_no
  result = wxPayRefund.getValues.hasKey("out_trade_no")
  
proc setOut_refund_no*(wxPayRefund: WxPayRefund, value: string) =
  ## 设置商户系统内部的退款单号，商户系统内部唯一，同一退款单号多次请求只退一笔
  wxPayRefund.setData("out_refund_no", value)

proc getOut_refund_no*(wxPayRefund: WxPayRefund): string =
  ## 获取商户系统内部的退款单号，商户系统内部唯一，同一退款单号多次请求只退一笔
  result = wxPayRefund.getData("out_refund_no")

proc isOut_refund_noSet*(wxPayRefund: WxPayRefund): bool =
  ## 判断商户系统内部的退款单号是否存在，商户系统内部唯一，同一退款单号多次请求只退一笔
  result = wxPayRefund.getValues.hasKey("out_refund_no")

proc setTotal_fee*(wxPayRefund: WxPayRefund, value: string) =
  ## 设置订单总金额，单位为分，只能为整数，详见支付金额
  wxPayRefund.setData("total_fee", value)

proc getTotal_fee*(wxPayRefund: WxPayRefund): string =
  ## 获取订单总金额，单位为分，只能为整数，详见支付金额
  result = wxPayRefund.getData("total_fee")

proc isTotal_feeSet*(wxPayRefund: WxPayRefund): bool =
  ## 判断订单总金额是否存在，单位为分，只能为整数，详见支付金额
  result = wxPayRefund.getValues.hasKey("total_fee")

proc setRefund_fee*(wxPayRefund: WxPayRefund, value: string) =
  ## 设置退款总金额，订单总金额，单位为分，只能为整数，详见支付金额
  wxPayRefund.setData("refund_fee", value)

proc getRefund_fee*(wxPayRefund: WxPayRefund): string =
  ## 获取退款总金额，订单总金额，单位为分，只能为整数，详见支付金额
  result = wxPayRefund.getData("refund_fee")

proc isRefund_feeSet*(wxPayRefund: WxPayRefund): bool =
  ## 判断退款总金额是否存在，订单总金额，单位为分，只能为整数，详见支付金额
  result = wxPayRefund.getValues.hasKey("refund_fee")

proc setRefund_fee_type*(wxPayRefund: WxPayRefund, value: string) =
  ## 设置货币类型，符合ISO 4217标准的三位字母代码，默认人民币：CNY，其他值列表详见货币类型
  wxPayRefund.setData("refund_fee_type", value)

proc getRefund_fee_type*(wxPayRefund: WxPayRefund): string =
  ## 获取货币类型，符合ISO 4217标准的三位字母代码，默认人民币：CNY，其他值列表详见货币类型
  result = wxPayRefund.getData("refund_fee_type")

proc isRefund_fee_typeSet*(wxPayRefund: WxPayRefund): bool =
  ## 判断货币类型是否存在，符合ISO 4217标准的三位字母代码，默认人民币：CNY，其他值列表详见货币类型
  result = wxPayRefund.getValues.hasKey("refund_fee_type")

proc setOp_user_id*(wxPayRefund: WxPayRefund, value: string) =
  ## 设置操作员帐号, 默认为商户号
  wxPayRefund.setData("op_user_id", value)

proc getOp_user_id*(wxPayRefund: WxPayRefund): string =
  ## 获取操作员帐号, 默认为商户号
  result = wxPayRefund.getData("op_user_id")

proc isOp_user_idSet*(wxPayRefund: WxPayRefund): bool =
  ## 判断操作员帐号是否存在, 默认为商户号
  result = wxPayRefund.getValues.hasKey("op_user_id")