import config
import results

type
  WxPayNotifyResults* = ref object of WxPayResults
  ## 通知结果基类

proc init*(wxPayNotifyResults: WxPayNotifyResults, config: WxPayConfig,
      xml: string): WxPayNotifyResults =
  ## 将xml转为WxPayNotifyResults
  var obj = WxPayNotifyResults()
  discard obj.fromXml(xml)
  # 失败则直接返回失败
  discard obj.checkSign(config);
  return obj