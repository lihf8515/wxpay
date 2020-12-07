type WxPayException* = system.Exception
  ## 微信支付API异常处理类

proc errorMessage*(): string =
  ## 显示出错信息，如果是Debug编译模式则显示堆栈跟踪信息，
  ## 如果不是Debug编译模式则不显示堆栈跟踪信息。
  var err = "异常信息：" & getCurrentExceptionMsg()
  when not defined(release) and not defined(danger):
    err.add("\n跟踪信息：\n")
    for i, item in getCurrentException().getStackTraceEntries:
      err.add($(i + 1) & "、在 " & $item.filename & " 文件的 " & $item.procname &
              " 函数；第 " & $item.line & " 行。\n")
  result = err
