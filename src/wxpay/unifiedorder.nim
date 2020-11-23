import tables

import database
export database

type
  WxPayUnifiedOrder* = ref object of WxPayDataBase
  ## 统一下单输入对象

proc setAppid*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayUnifiedOrder.setData("appid", value) 

proc getAppid*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取微信分配的公众账号ID
  result = wxPayUnifiedOrder.getData("appid")

proc isAppidSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayUnifiedOrder.getValues.hasKey("appid")

proc setMch_id*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置微信支付分配的商户号
  wxPayUnifiedOrder.setData("mch_id", value)

proc getMch_id*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取微信支付分配的商户号
  result = wxPayUnifiedOrder.getData("mch_id")

proc isMch_idSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断微信支付分配的商户号是否存在
  result = wxPayUnifiedOrder.getValues.hasKey("mch_id")

proc setDevice_info*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置微信支付分配的终端设备号，商户自定义
  wxPayUnifiedOrder.setData("device_info", value)

proc getDevice_info*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取微信支付分配的终端设备号，商户自定义
  result = wxPayUnifiedOrder.getData("device_info")

proc isDevice_infoSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断微信支付分配的终端设备号是否存在，商户自定义
  result = wxPayUnifiedOrder.getValues.hasKey("device_info")

proc setNonce_str*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置随机字符串，不长于32位。推荐随机数生成算法
  wxPayUnifiedOrder.setData("nonce_str", value)

proc getNonce_str*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取随机字符串，不长于32位。推荐随机数生成算法
  result = wxPayUnifiedOrder.getData("nonce_str")

proc isNonce_strSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断随机字符串是否存在，不长于32位。推荐随机数生成算法
  result = wxPayUnifiedOrder.getValues.hasKey("nonce_str")

proc setBody*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置商品或支付单简要描述
  wxPayUnifiedOrder.setData("body", value)

proc getBody*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取商品或支付单简要描述
  result = wxPayUnifiedOrder.getData("body")

proc isBodySet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断商品或支付单简要描述是否存在
  result = wxPayUnifiedOrder.getValues.hasKey("body")

proc setDetail*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置商品名称明细列表
  wxPayUnifiedOrder.setData("detail", value)

proc getDetail*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取商品名称明细列表
  result = wxPayUnifiedOrder.getData("detail")

proc isDetailSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断商品名称明细列表是否存在
  result = wxPayUnifiedOrder.getValues.hasKey("detail")

proc setAttach*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置附加数据，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
  wxPayUnifiedOrder.setData("attach", value)

proc getAttach*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取附加数据，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
  result = wxPayUnifiedOrder.getData("attach")

proc isAttachSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断附加数据是否存在，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
  result = wxPayUnifiedOrder.getValues.hasKey("attach")

proc setOut_trade_no*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置商户系统内部的订单号,32个字符内、可包含字母, 其他说明见商户订单号
  wxPayUnifiedOrder.setData("out_trade_no", value)

proc getOut_trade_no*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取商户系统内部的订单号,32个字符内、可包含字母, 其他说明见商户订单号
  result = wxPayUnifiedOrder.getData("out_trade_no")

proc isOut_trade_noSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断商户系统内部的订单号是否存在,32个字符内、可包含字母, 其他说明见商户订单号
  result = wxPayUnifiedOrder.getValues.hasKey("out_trade_no")

proc setFee_type*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置符合ISO 4217标准的三位字母代码，默认人民币：CNY，其他值列表详见货币类型
  wxPayUnifiedOrder.setData("fee_type", value)

proc getFee_type*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取符合ISO 4217标准的三位字母代码，默认人民币：CNY，其他值列表详见货币类型
  result = wxPayUnifiedOrder.getData("fee_type")

proc isFee_typeSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断符合ISO 4217标准的三位字母代码是否存在，默认人民币：CNY，其他值列表详见货币类型
  result = wxPayUnifiedOrder.getValues.hasKey("fee_type")

proc setTotal_fee*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置订单总金额，只能为整数，详见支付金额
  wxPayUnifiedOrder.setData("total_fee", value)

proc getTotal_fee*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取订单总金额，只能为整数，详见支付金额
  result = wxPayUnifiedOrder.getData("total_fee")

proc isTotal_feeSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断订单总金额是否存在，只能为整数，详见支付金额
  result = wxPayUnifiedOrder.getValues.hasKey("total_fee")

proc setSpbill_create_ip*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP
  wxPayUnifiedOrder.setData("spbill_create_ip", value)

proc getSpbill_create_ip*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP
  result = wxPayUnifiedOrder.getData("spbill_create_ip")

proc isSpbill_create_ipSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断APP和网页支付提交用户端ip是否存在，Native支付填调用微信支付API的机器IP
  result = wxPayUnifiedOrder.getValues.hasKey("spbill_create_ip")

proc setTime_start*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置订单生成时间，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010。其他详见时间规则
  wxPayUnifiedOrder.setData("time_start", value)

proc getTime_start*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取订单生成时间，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010。其他详见时间规则
  result = wxPayUnifiedOrder.getData("time_start")

proc isTime_startSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断订单生成时间是否存在，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010。其他详见时间规则
  result = wxPayUnifiedOrder.getValues.hasKey("time_start")

proc setTime_expire*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置订单失效时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。其他详见时间规则
  wxPayUnifiedOrder.setData("time_expire", value)

proc getTime_expire*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取订单失效时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。其他详见时间规则
  result = wxPayUnifiedOrder.getData("time_expire")

proc isTime_expireSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断订单失效时间是否存在，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。其他详见时间规则
  result = wxPayUnifiedOrder.getValues.hasKey("time_expire")

proc setGoods_tag*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置商品标记，代金券或立减优惠功能的参数，说明详见代金券或立减优惠
  wxPayUnifiedOrder.setData("goods_tag", value)

proc getGoods_tag*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取商品标记，代金券或立减优惠功能的参数，说明详见代金券或立减优惠
  result = wxPayUnifiedOrder.getData("goods_tag")

proc isGoods_tagSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断商品标记是否存在，代金券或立减优惠功能的参数，说明详见代金券或立减优惠
  result = wxPayUnifiedOrder.getValues.hasKey("goods_tag")

proc setNotify_url*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置接收微信支付异步通知回调地址
  wxPayUnifiedOrder.setData("notify_url", value)

proc getNotify_url*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取接收微信支付异步通知回调地址
  result = wxPayUnifiedOrder.getData("notify_url")

proc isNotify_urlSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断接收微信支付异步通知回调地址是否存在
  result = wxPayUnifiedOrder.getValues.hasKey("notify_url")

proc setTrade_type*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置取值如下：JSAPI，NATIVE，APP，详细说明见参数规定
  wxPayUnifiedOrder.setData("trade_type", value)

proc getTrade_type*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取取值如下：JSAPI，NATIVE，APP，详细说明见参数规定
  result = wxPayUnifiedOrder.getData("trade_type")

proc isTrade_typeSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断取值如下：JSAPI，NATIVE，APP，详细说明见参数规定
  result = wxPayUnifiedOrder.getValues.hasKey("trade_type")

proc setProduct_id*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置商品ID，trade_type=NATIVE，此参数必传。此id为二维码中包含的商品ID，商户自行定义
  wxPayUnifiedOrder.setData("product_id", value)

proc getProduct_id*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取商品ID，trade_type=NATIVE，此参数必传。此id为二维码中包含的商品ID，商户自行定义
  result = wxPayUnifiedOrder.getData("product_id")

proc isProduct_idSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断商品ID是否存在，trade_type=NATIVE，此参数必传。此id为二维码中包含的商品ID，商户自行定义
  result = wxPayUnifiedOrder.getValues.hasKey("product_id")

proc setOpenid*(wxPayUnifiedOrder: WxPayUnifiedOrder, value: string) =
  ## 设置Openid,trade_type=JSAPI，此参数必传，用户在商户appid下的唯一标识。
  ## 下单前需要调用【网页授权获取用户信息】接口获取到用户的Openid
  wxPayUnifiedOrder.setData("openid", value)

proc getOpenid*(wxPayUnifiedOrder: WxPayUnifiedOrder): string =
  ## 获取Openid,trade_type=JSAPI，此参数必传，用户在商户appid下的唯一标识。
  ## 下单前需要调用【网页授权获取用户信息】接口获取到用户的Openid
  result = wxPayUnifiedOrder.getData("openid")

proc isOpenidSet*(wxPayUnifiedOrder: WxPayUnifiedOrder): bool =
  ## 判断Openid是否存在,trade_type=JSAPI，此参数必传，用户在商户appid下的唯一标识。
  ## 下单前需要调用【网页授权获取用户信息】接口获取到用户的Openid
  result = wxPayUnifiedOrder.getValues.hasKey("openid")
