import tables
import wxpay

var succFlag: bool
var input, config = OrderedTable[string, string]()
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

input["out_refund_no"] = "132564989589668"
input["out_trade_no"] = "test00000001"
input["refund_fee"] = "1"
input["total_fee"] = "1"

try:
  var ret = wxRefund(input, config, succFlag)
  if succFlag:
    echo "请求退款成功"
    echo ret
  else:
    echo "请求退款失败"
    echo ret
except:
  echo wxErrorMessage()
