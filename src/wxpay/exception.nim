type WxPayException* = system.Exception
  ## 微信支付API异常处理类

proc errorMessage*(): string =
  result = "获取到异常 " & repr(getCurrentException()) &
           " 消息： " & getCurrentExceptionMsg()
