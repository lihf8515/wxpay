import tables
import wxpay
import wxpay/exception

var succFlag: bool
var input, config = OrderedTableRef[string, string]()
config["appid"] = ""
config["appsecret"] = ""
config["key"] = ""
config["mch_id"] = ""
config["notify_url"] = ""
config["proxy_host"] = "0.0.0.0"
config["proxy_port"] = "0"
config["report_level"] = "1"
config["sslcert_path"] = ""
config["sslkey_path"] = ""
config["sign_type"] = "HMAC-SHA256"

input["auth_code"] = ""
input["body"] = "付款码支付测试"
input["total_fee"] = "1"
input["out_trade_no"] = "00001"


try:
  var ret = wxMicropay(input, config, succFlag)
  if succFlag:
    echo "支付成功"
    echo ret
  else:
    echo "支付失败"
    echo ret
except:
  echo wxErrorMessage()
