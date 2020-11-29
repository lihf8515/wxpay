# wxpay
A wechat payment sdk for nim.

目前，已经实现的功能：
1、付款码支付。
2、申请退款。

下面是一个例子：
``` nim
import tables
import wxpay

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
  
var input1 = OrderedTable[string, string]()
input1["out_refund_no"] = "132564989589668"
input1["out_trade_no"] = "test00000001"
input1["refund_fee"] = "1"
input1["total_fee"] = "1"

try:
  var ret1 = wxRefund(input1, config, succFlag)
  if succFlag:
    echo "请求退款成功"
    echo ret1
  else:
    echo "请求退款失败"
    echo ret1
except:
  echo wxErrorMessage()
  
```
