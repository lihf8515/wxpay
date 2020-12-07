type WxPayException* = system.Exception
  ## 微信支付API异常处理类

proc errorMessage*(): string =
  var err = "异常信息：" & getCurrentExceptionMsg() & "\n跟踪信息："
  for item in getCurrentException().getStackTraceEntries:
    err.add($item & "\n\n")
  result = err
