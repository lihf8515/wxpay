import tables
import strutils
import md5

import hmac

import config
import exception
import database
export database

type
  WxPayResults* = ref object of WxPayDataBase
    ## 接口调用结果类，继承自数据对象基类``WxPayDataBase``

proc makeSign*(wxPayResults: WxPayResults, config: WxPayConfig,
        needSignType = false): string =
  ## 重载数据对象基类的``makeSign``函数，主要用于接口调用结果的验证,
  ## 生成并返回签名，本函数不覆盖sign成员变量，如要设置签名需要调用setSign方法赋值

  # 签名步骤一：按字典序排序参数
  sort(wxPayResults.getValues, system.cmp)
  var s = wxPayResults.toUrlParams()
  # 签名步骤二：在s后加入KEY
  s.add "&key=" & config.getKey()
  # 签名步骤三：MD5加密或者HMAC-SHA256
  if wxPayResults.getSign().len <= 32:
    # 如果签名小于等于32个,则使用md5验证
    s = getMD5(s)
  else:
    # 用sha256校验
    s = toHex(hmac_sha256(config.getKey(), s))

  # 签名步骤四：所有字符转为大写
  result = toUpper(s)

proc checkSign*(wxPayResults: WxPayResults, config: WxPayConfig): bool =
  ## 检测签名
  if not wxPayResults.isSignSet():
    raise newException(WxPayException, "签名错误！")
  
  let sign = wxPayResults.makeSign(config, false)
  if wxPayResults.getSign() == sign:
    # 签名正确
    result = true
  else:
    raise newException(WxPayException, "签名错误！")

proc initWxPayResults*(config: WxPayConfig,
                       orderedTable: OrderedTableRef[string, string],
                       noCheckSign = false): WxPayResults =
  ## 使用OrderedTableRef初始化WxPayResults对象
  var obj = WxPayResults()
  obj.setValues(orderedTable)
  if noCheckSign == false:
    discard obj.checkSign(config)

  result = obj

proc initWxPayResults*(config: WxPayConfig, xml: string): WxPayResults =
  ## 使用xml字符串初始化WxPayResults对象
  var wxPayResults = WxPayResults()
  wxPayResults = initWxPayResults(config, wxPayResults.fromXml(xml))
  
  # 失败则直接返回失败
  if wxPayResults.getData("return_code") != "SUCCESS":
    for key, value in wxPayResults.getValues:
      # 除了return_code和return_msg之外其他的参数存在，则报错
      if key != "return_code" and key != "return_msg":
        raise newException(WxPayException, "输入数据存在异常！")
    return wxPayResults

  discard wxPayResults.checkSign(config)
  return wxPayResults
