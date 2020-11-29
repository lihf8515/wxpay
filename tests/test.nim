import tables

proc errorMessage(): string {.stdcall,importc:"wxErrorMessage",dynlib:"wxpay.dll".}
proc wxmicropay(data, config: OrderedTable[string, string],
                succFlag: var bool): OrderedTable[string, string]
               {.stdcall,importc:"wxMicropay",dynlib:"wxpay.dll".}
proc wxrefund(data, config: OrderedTable[string, string],
                succFlag: var bool): OrderedTable[string, string]
               {.stdcall,importc:"wxRefund",dynlib:"wxpay.dll".} 
               
var succFlag: bool
var input = OrderedTable[string, string]()
var config = OrderedTable[string, string]()
config["appid"] = ""
config["appsecret"] = ""
config["key"] = ""
config["mch_id"] = ""
config["notify_url"] = ""
config["proxy_host"] = "0.0.0.0"
config["proxy_port"] = "0"
config["report_level"] = "1"
config["sslcert_path"] = "cert/apiclient_cert.pem"
config["sslkey_path"] = "cert/apiclient_key.pem"
config["sign_type"] = "HMAC-SHA256"

input["auth_code"] = "134728953980228598"
input["body"] = "付款码支付测试"
input["total_fee"] = "1"
input["out_trade_no"] = "test00000001"

try:
  var ret = wxmicropay(input, config, succFlag)
  if succFlag:
    echo "支付成功"
    echo ret
  else:
    echo "支付失败"
    echo ret
except:
  echo errorMessage()


var input1 = OrderedTable[string, string]()
input1["out_refund_no"] = "132564989589668"
input1["out_trade_no"] = "test00000001"
input1["refund_fee"] = "1"
input1["total_fee"] = "1"

try:
  var ret1 = wxrefund(input1, config, succFlag)
  if succFlag:
    echo "请求退款成功"
    echo ret1
  else:
    echo "请求退款失败"
    echo ret1
except:
  echo errorMessage()
