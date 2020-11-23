import tables

import database

type WxPayReport* = ref object of WxPayDataBase
  ## 测速上报输入对象

proc setAppid*(wxPayReport: WxPayReport, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayReport.setData("appid", value)

proc getAppid*(wxPayReport: WxPayReport): string =
  ## 获取微信分配的公众账号ID
  result = wxPayReport.getData("appid")

proc isAppidSet*(wxPayReport: WxPayReport): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayReport.getValues.hasKey("appid")

proc setMch_id*(wxPayReport: WxPayReport, value: string) =
  ## 设置微信支付分配的商户号
  wxPayReport.setData("mch_id", value)

proc getMch_id*(wxPayReport: WxPayReport): string =
  ## 获取微信支付分配的商户号
  result = wxPayReport.getData("mch_id")

proc isMch_idSet*(wxPayReport: WxPayReport): bool =
  ## 判断微信支付分配的商户号是否存在
  result = wxPayReport.getValues.hasKey("mch_id")

proc setDevice_info*(wxPayReport: WxPayReport, value: string) =
  ## 设置微信支付分配的终端设备号，商户自定义
  wxPayReport.setData("device_info", value)

proc getDevice_info*(wxPayReport: WxPayReport): string =
  ## 获取微信支付分配的终端设备号，商户自定义
  result = wxPayReport.getData("device_info")

proc isDevice_infoSet*(wxPayReport: WxPayReport): bool =
  ## 判断微信支付分配的终端设备号是否存在，商户自定义
  result = wxPayReport.getValues.hasKey("device_info")

proc setNonce_str*(wxPayReport: WxPayReport, value: string) =
  ## 设置随机字符串，不长于32位。推荐随机数生成算法
  wxPayReport.setData("nonce_str", value)

proc getNonce_str*(wxPayReport: WxPayReport): string =
  ## 获取随机字符串，不长于32位。推荐随机数生成算法
  result = wxPayReport.getData("nonce_str")

proc isNonce_strSet*(wxPayReport: WxPayReport): bool =
  ## 判断随机字符串是否存在，不长于32位。推荐随机数生成算法
  result = wxPayReport.getValues.hasKey("nonce_str")

proc setInterface_url*(wxPayReport: WxPayReport, value: string) =
  ## 设置上报对应的接口的完整URL，类似：https://api.mch.weixin.qq.com/pay/unifiedorder,
  ## 对于被扫支付，为更好的和商户共同分析一次业务行为的整体耗时情况，
  ## 对于两种接入模式，请都在门店侧对一次被扫行为进行一次单独的整体上报，
  ## 上报URL指定为：https://api.mch.weixin.qq.com/pay/micropay/total关于两种接入,
  ## 模式具体可参考本文档章节：被扫支付商户接入模式其它接口调用仍然按照调用一次，上报一次来进行
  wxPayReport.setData("interface_url", value)

proc getInterface_url*(wxPayReport: WxPayReport): string =
  ## 获取上报对应的接口的完整URL，类似：https://api.mch.weixin.qq.com/pay/unifiedorder对于被扫支付，
  ## 为更好的和商户共同分析一次业务行为的整体耗时情况，对于两种接入模式，
  ## 请都在门店侧对一次被扫行为进行一次单独的整体上报，
  ## 上报URL指定为：https://api.mch.weixin.qq.com/pay/micropay/total,
  ## 关于两种接入模式具体可参考本文档章节：被扫支付商户接入模式其它接口调用仍然按照调用一次，上报一次来进行
  result = wxPayReport.getData("interface_url")

proc isInterface_urlSet*(wxPayReport: WxPayReport): bool =
  ## 判断上报对应的接口的完整URL是否存在，类似：https://api.mch.weixin.qq.com/pay/unifiedorder对于被扫支付，
  ## 为更好的和商户共同分析一次业务行为的整体耗时情况，对于两种接入模式，
  ## 请都在门店侧对一次被扫行为进行一次单独的整体上报，
  ## 上报URL指定为：https://api.mch.weixin.qq.com/pay/micropay/total,
  ## 关于两种接入模式具体可参考本文档章节：被扫支付商户接入模式其它接口调用仍然按照调用一次，上报一次来进行
  result = wxPayReport.getValues.hasKey("interface_url")

proc setExecute_time*(wxPayReport: WxPayReport, value: string) =
  ## 设置接口耗时情况，单位为毫秒
  wxPayReport.setData("execute_time_", value)

proc getExecute_time*(wxPayReport: WxPayReport): string =
  ## 获取接口耗时情况，单位为毫秒
  result = wxPayReport.getData("execute_time_")

proc isExecute_timeSet*(wxPayReport: WxPayReport): bool =
  ## 判断接口耗时情况，单位为毫秒是否存在
  result = wxPayReport.getValues.hasKey("execute_time_")

proc setReturn_code*(wxPayReport: WxPayReport, value: string) =
  ## 设置返回码，SUCCESS/FAIL,此字段是通信标识，非交易标识，交易是否成功需要查看trade_state来判断
  wxPayReport.setData("return_code", value)

proc getReturn_code*(wxPayReport: WxPayReport): string =
  ## 获取返回码，SUCCESS/FAIL,此字段是通信标识，非交易标识，交易是否成功需要查看trade_state来判断
  result = wxPayReport.getData("return_code")

proc isReturn_codeSet*(wxPayReport: WxPayReport): bool =
  ## 判断返回码是否存在,此字段是通信标识，非交易标识，交易是否成功需要查看trade_state来判断
  result = wxPayReport.getValues.hasKey("return_code")

proc setReturn_msg*(wxPayReport: WxPayReport, value: string) =
  ## 设置返回信息，如非空，为错误原因签名失败参数格式校验错误
  wxPayReport.setData("return_msg", value)

proc getReturn_msg*(wxPayReport: WxPayReport): string =
  ## 获取返回信息，如非空，为错误原因签名失败参数格式校验错误
  result = wxPayReport.getData("return_msg")

proc isReturn_msgSet*(wxPayReport: WxPayReport): bool =
  ## 判断返回信息是否存在，如非空，错误原因签名失败参数格式校验错误
  result = wxPayReport.getValues.hasKey("return_msg")

proc setResult_code*(wxPayReport: WxPayReport, value: string) =
  ## 设置SUCCESS/FAIL
  wxPayReport.setData("result_code", value)

proc getResult_code*(wxPayReport: WxPayReport): string =
  ## 获取SUCCESS/FAIL
  result = wxPayReport.getData("result_code")

proc isResult_codeSet*(wxPayReport: WxPayReport): bool =
  ## 判断SUCCESS/FAIL是否存在
  result = wxPayReport.getValues.hasKey("result_code")

proc setErr_code*(wxPayReport: WxPayReport, value: string) =
  ## 设置错误码，ORDERNOTEXIST—订单不存在，SYSTEMERROR—系统错误
  wxPayReport.setData("err_code", value)

proc getErr_code*(wxPayReport: WxPayReport): string =
  ## 获取错误码，ORDERNOTEXIST—订单不存在，SYSTEMERROR—系统错误
  result = wxPayReport.getData("err_code")

proc isErr_codeSet*(wxPayReport: WxPayReport): bool =
  ## 判断错误码是否存在
  result = wxPayReport.getValues.hasKey("err_code")

proc setErr_code_des*(wxPayReport: WxPayReport, value: string) =
  ## 设置结果信息描述
  wxPayReport.setData("err_code_des", value)

proc getErr_code_des*(wxPayReport: WxPayReport): string =
  ## 获取结果信息描述
  result = wxPayReport.getData("err_code_des")

proc isErr_code_desSet*(wxPayReport: WxPayReport): bool =
  ## 判断结果信息描述是否存在
  result = wxPayReport.getValues.hasKey("err_code_des")

proc setOut_trade_no*(wxPayReport: WxPayReport, value: string) =
  ## 设置商户系统内部的订单号,商户可以在上报时提供相关商户订单号方便微信支付更好的提高服务质量
  wxPayReport.setData("out_trade_no", value)

proc getOut_trade_no*(wxPayReport: WxPayReport): string =
  ## 获取商户系统内部的订单号,商户可以在上报时提供相关商户订单号方便微信支付更好的提高服务质量
  result = wxPayReport.getData("out_trade_no")

proc isOut_trade_noSet*(wxPayReport: WxPayReport): bool =
  ## 判断商户系统内部的订单号是否存在,商户可以在上报时提供相关商户订单号方便微信支付更好的提高服务质量
  result = wxPayReport.getValues.hasKey("out_trade_no")

proc setUser_ip*(wxPayReport: WxPayReport, value: string) =
  ## 设置发起接口调用时的机器IP
  wxPayReport.setData("user_ip", value)

proc getUser_ip*(wxPayReport: WxPayReport): string =
  ## 获取发起接口调用时的机器IP
  result = wxPayReport.getData("user_ip")

proc isUser_ipSet*(wxPayReport: WxPayReport): bool =
  ## 判断发起接口调用时的机器IP是否存在
  result = wxPayReport.getValues.hasKey("user_ip")

proc setTime*(wxPayReport: WxPayReport, value: string) =
  ## 设置系统时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。其他详见时间规则
  wxPayReport.setData("time", value)

proc getTime*(wxPayReport: WxPayReport): string =
  ## 获取系统时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。其他详见时间规则
  result = wxPayReport.getData("time")

proc isTimeSet*(wxPayReport: WxPayReport): bool =
  ## 判断系统时间是否存在，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。其他详见时间规则
  result = wxPayReport.getValues.hasKey("time")