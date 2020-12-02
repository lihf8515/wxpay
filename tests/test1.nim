import tables
import wxpay

var results = OrderedTable[string, string]()
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

input["auth_code"] = "138728953980228598"
input["body"] = "付款码支付测试"
input["total_fee"] = "1"
input["out_trade_no"] = "test00000001"

try:
  if wxMicropay(input, config, results):
    echo "支付成功"
    echo results
  else:
    echo "支付失败"
    echo results
except:
  echo wxErrorMessage()

results.clear()
input.clear()
input["out_refund_no"] = "132564989589668"
input["out_trade_no"] = "test00000001"
input["refund_fee"] = "1"
input["total_fee"] = "1"

try:
  if wxRefund(input, config, results):
    echo "请求退款成功"
    echo results
  else:
    echo "请求退款失败"
    echo results
except:
  echo wxErrorMessage()
