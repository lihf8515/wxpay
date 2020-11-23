import databasemd5
export databasemd5

type
  WxPayNotifyReply* = ref object of WxPayDataBaseSignMd5
  ## 通知回复基类

proc setReturn_code*(wxPayNotifyReply: WxPayNotifyReply, return_code: string): string =
  ## 设置错误码 FAIL 或者 SUCCESS
  wxPayNotifyReply.setData("return_code", return_code)
  result = return_code

proc getReturn_code*(wxPayNotifyReply: WxPayNotifyReply): string =
  ## 获取错误码 FAIL 或者 SUCCESS
  result = wxPayNotifyReply.getData("return_code")

proc setReturn_msg*(wxPayNotifyReply: WxPayNotifyReply, return_msg: string): string =
  ## 设置错误信息
  wxPayNotifyReply.setData("return_msg", return_msg)
  result = return_msg

proc getReturn_msg*(wxPayNotifyReply: WxPayNotifyReply): string =
  ## 获取错误信息
  result = wxPayNotifyReply.getData("return_msg")

proc setValues*(wxPayNotifyReply: WxPayNotifyReply, key, value: string) =
  ## 设置返回参数
  wxPayNotifyReply.setData(key, value)