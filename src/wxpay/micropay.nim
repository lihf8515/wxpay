import tables

import database

type WxPayMicroPay* = ref object of WxPayDataBase
  ## 提交被扫输入对象

proc setAppid*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayMicroPay.setData("appid", value)

proc getAppid*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取微信分配的公众账号ID
  result = wxPayMicroPay.getData("appid")

proc isAppidSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayMicroPay.getValues.hasKey("appid")

proc setMch_id*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置微信支付分配的商户号
  wxPayMicroPay.setData("mch_id", value)

proc getMch_id*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取微信支付分配的商户号
  result = wxPayMicroPay.getData("mch_id")

proc isMch_idSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断微信支付分配的商户号是否存在
  result = wxPayMicroPay.getValues.hasKey("mch_id")

proc setDevice_info*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置终端设备号(商户自定义，如门店编号)
  wxPayMicroPay.setData("device_info", value)

proc getDevice_info*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取终端设备号(商户自定义，如门店编号)
  result = wxPayMicroPay.getData("device_info")

proc isDevice_infoSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断终端设备号是否存在(商户自定义，如门店编号)
  result = wxPayMicroPay.getValues.hasKey("device_info")

proc setNonce_str*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置随机字符串，不长于32位。推荐随机数生成算法
  wxPayMicroPay.setData("nonce_str", value)

proc getNonce_str*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取随机字符串，不长于32位。推荐随机数生成算法
  result = wxPayMicroPay.getData("nonce_str")

proc isNonce_strSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断随机字符串是否存在，不长于32位。推荐随机数生成算法
  result = wxPayMicroPay.getValues.hasKey("nonce_str")

proc setBody*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置商品或支付单简要描述
  wxPayMicroPay.setData("body", value)

proc getBody*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取商品或支付单简要描述
  result = wxPayMicroPay.getData("body")

proc isBodySet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断商品或支付单简要描述是否存在
  result = wxPayMicroPay.getValues.hasKey("body")

proc setDetail*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置商品名称明细列表
  wxPayMicroPay.setData("detail", value)

proc getDetail*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取商品名称明细列表
  result = wxPayMicroPay.getData("detail")

proc isDetailSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断商品名称明细列表是否存在
  result = wxPayMicroPay.getValues.hasKey("detail")

proc setAttach*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置附加数据，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
  wxPayMicroPay.setData("attach", value)

proc getAttach*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取附加数据，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
  result = wxPayMicroPay.getData("attach")

proc isAttachSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断附加数据是否存在，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
  result = wxPayMicroPay.getValues.hasKey("attach")

proc setOut_trade_no*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置商户系统内部的订单号,32个字符内、可包含字母, 其他说明见商户订单号
  wxPayMicroPay.setData("out_trade_no", value)

proc getOut_trade_no*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取商户系统内部的订单号,32个字符内、可包含字母, 其他说明见商户订单号
  result = wxPayMicroPay.getData("out_trade_no")

proc isOut_trade_noSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断商户系统内部的订单号是否存在,32个字符内、可包含字母, 其他说明见商户订单号
  result = wxPayMicroPay.getValues.hasKey("out_trade_no")

proc setTotal_fee*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置订单总金额，单位为分，只能为整数，详见支付金额
  wxPayMicroPay.setData("total_fee", value)

proc getTotal_fee*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取订单总金额，单位为分，只能为整数，详见支付金额
  result = wxPayMicroPay.getData("total_fee")

proc isTotal_feeSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断订单总金额是否存在，单位为分，只能为整数，详见支付金额
  result = wxPayMicroPay.getValues.hasKey("total_fee")

proc setFee_type*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置符合ISO 4217标准的三位字母代码，默认人民币：CNY，其他值列表详见货币类型
  wxPayMicroPay.setData("fee_type", value)

proc getFee_type*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取符合ISO 4217标准的三位字母代码，默认人民币：CNY，其他值列表详见货币类型
  result = wxPayMicroPay.getData("fee_type")

proc isFee_typeSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断符合ISO 4217标准的三位字母代码是否存在，默认人民币：CNY，其他值列表详见货币类型
  result = wxPayMicroPay.getValues.hasKey("fee_type")

proc setSpbill_create_ip*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置调用微信支付API的机器IP
  wxPayMicroPay.setData("spbill_create_ip", value)

proc getSpbill_create_ip*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取调用微信支付API的机器IP
  result = wxPayMicroPay.getData("spbill_create_ip")

proc isSpbill_create_ipSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断调用微信支付API的机器IP是否存在
  result = wxPayMicroPay.getValues.hasKey("spbill_create_ip")

proc setTime_start*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置订单生成时间，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010。详见时间规则
  wxPayMicroPay.setData("time_start", value)

proc getTime_start*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取订单生成时间，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010。详见时间规则
  result = wxPayMicroPay.getData("time_start")

proc isTime_startSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断订单生成时间是否存在，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010。详见时间规则
  result = wxPayMicroPay.getValues.hasKey("time_start")

proc setTime_expire*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置订单失效时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。详见时间规则
  wxPayMicroPay.setData("time_expire", value)

proc getTime_expire*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取订单失效时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。详见时间规则
  result = wxPayMicroPay.getData("time_expire")

proc isTime_expireSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断订单失效时间是否存在，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。详见时间规则
  result = wxPayMicroPay.getValues.hasKey("time_expire")

proc setGoods_tag*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置商品标记，代金券或立减优惠功能的参数，说明详见代金券或立减优惠
  wxPayMicroPay.setData("goods_tag", value)

proc getGoods_tag*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取商品标记，代金券或立减优惠功能的参数，说明详见代金券或立减优惠
  result = wxPayMicroPay.getData("goods_tag")

proc isGoods_tagSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断商品标记是否存在，代金券或立减优惠功能的参数，说明详见代金券或立减优惠
  result = wxPayMicroPay.getValues.hasKey("goods_tag")

proc setAuth_code*(wxPayMicroPay: WxPayMicroPay, value: string) =
  ## 设置扫码支付授权码，即设备读取用户微信中的条码或者二维码信息
  wxPayMicroPay.setData("auth_code", value)

proc getAuth_code*(wxPayMicroPay: WxPayMicroPay): string =
  ## 获取扫码支付授权码，即设备读取用户微信中的条码或者二维码信息
  result = wxPayMicroPay.getData("auth_code")

proc isAuth_codeSet*(wxPayMicroPay: WxPayMicroPay): bool =
  ## 判断扫码支付授权码是否存在，设备读取用户微信中的条码或者二维码信息
  result = wxPayMicroPay.getValues.hasKey("auth_code")
