import tables

import database

type WxPayDownloadBill* = ref object of WxPayDataBase
  ## 下载对账单输入对象

proc setAppid*(wxPayDownloadBill: WxPayDownloadBill, value: string) =
  ## 设置微信分配的公众账号ID
  wxPayDownloadBill.setData("appid", value)

proc getAppid*(wxPayDownloadBill: WxPayDownloadBill): string =
  ## 获取微信分配的公众账号ID
  result = wxPayDownloadBill.getData("appid")

proc isAppidSet*(wxPayDownloadBill: WxPayDownloadBill): bool =
  ## 判断微信分配的公众账号ID是否存在
  result = wxPayDownloadBill.getValues.hasKey("appid")

proc setMch_id*(wxPayDownloadBill: WxPayDownloadBill, value: string) =
  ## 设置微信支付分配的商户号
  wxPayDownloadBill.setData("mch_id", value)

proc getMch_id*(wxPayDownloadBill: WxPayDownloadBill): string =
  ## 获取微信支付分配的商户号
  result = wxPayDownloadBill.getData("mch_id")

proc isMch_idSet*(wxPayDownloadBill: WxPayDownloadBill): bool =
  ## 判断微信支付分配的商户号是否存在
  result = wxPayDownloadBill.getValues.hasKey("mch_id")

proc setDevice_info*(wxPayDownloadBill: WxPayDownloadBill, value: string) =
  ## 设置微信支付分配的终端设备号，填写此字段，只下载该设备号的对账单
  wxPayDownloadBill.setData("device_info", value)

proc getDevice_info*(wxPayDownloadBill: WxPayDownloadBill): string =
  ## 获取微信支付分配的终端设备号，填写此字段，只下载该设备号的对账单
  result = wxPayDownloadBill.getData("device_info")

proc isDevice_infoSet*(wxPayDownloadBill: WxPayDownloadBill): bool =
  ## 判断微信支付分配的终端设备号，填写此字段，只下载该设备号的对账单是否存在
  result = wxPayDownloadBill.getValues.hasKey("device_info")

proc setNonce_str*(wxPayDownloadBill: WxPayDownloadBill, value: string) =
  ## 设置随机字符串，不长于32位。推荐随机数生成算法
  wxPayDownloadBill.setData("nonce_str", value)

proc getNonce_str*(wxPayDownloadBill: WxPayDownloadBill): string =
  ## 获取随机字符串，不长于32位。推荐随机数生成算法
  result = wxPayDownloadBill.getData("nonce_str")

proc isNonce_strSet*(wxPayDownloadBill: WxPayDownloadBill): bool =
  ## 判断随机字符串是否存在，不长于32位。推荐随机数生成算法
  result = wxPayDownloadBill.getValues.hasKey("nonce_str")

proc setBill_date*(wxPayDownloadBill: WxPayDownloadBill, value: string) =
  ## 设置下载对账单的日期，格式：20140603
  wxPayDownloadBill.setData("bill_date", value)

proc getBill_date*(wxPayDownloadBill: WxPayDownloadBill): string =
  ## 获取下载对账单的日期，格式：20140603
  result = wxPayDownloadBill.getData("bill_date")

proc isBill_dateSet*(wxPayDownloadBill: WxPayDownloadBill): bool =
  ## 判断下载对账单的日期是否存在，格式：20140603
  result = wxPayDownloadBill.getValues.hasKey("bill_date")

proc setBill_type*(wxPayDownloadBill: WxPayDownloadBill, value: string) =
  ## 设置下载类型，
  ## ALL：当日所有订单信息,
  ## SUCCESS：默认值，当日成功支付的订单,
  ## REFUND：当日退款订单,
  ## REVOKED：已撤销的订单
  wxPayDownloadBill.setData("bill_type", value)

proc getBill_type*(wxPayDownloadBill: WxPayDownloadBill): string =
  ## 获取下载类型，
  ## ALL：当日所有订单信息,
  ## SUCCESS：默认值，当日成功支付的订单,
  ## REFUND：当日退款订单,
  ## REVOKED：已撤销的订单
  result = wxPayDownloadBill.getData("bill_type")

proc isBill_typeSet*(wxPayDownloadBill: WxPayDownloadBill): bool =
  ## 判断下载类型是否设置
  result = wxPayDownloadBill.getValues.hasKey("bill_type")