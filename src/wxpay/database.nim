import tables
import xmltree, xmlparser
import strutils
import md5

import hmac

import private/utils
import config
import exception

type
  WxPayDataBase* = ref object of RootObj
    ## 数据对象基类，该类中定义数据类最基本的行为，包括：
    ## 计算/设置/获取签名、输出xml格式的参数、从xml读取数据对象等
    values: OrderedTableRef[string, string] ## 数据对象基类的数据信息，用有序表存储

method setSignType*(wxdb: WxPayDataBase, signType: string): string {.base.} =
  ## 设置签名类型，详见签名生成算法类型
  wxdb.values["sign_type"] = signType
  result = signType
 
method getSign*(wxdb: WxPayDataBase): string {.base.} =
  ## 获取签名，详见签名生成算法的值
  result = wxdb.values["sign"]
  
method isSignSet*(wxdb: WxPayDataBase): bool {.base.} =
  ## 判断签名，详见签名生成算法是否存在
  result = wxdb.values.hasKey("sign")

method toXml*(wxdb: WxPayDataBase): string {.base.} =
  ## 输出xml字符
  if wxdb.values.len <= 0:
    raise newException(WxPayException, "数组数据异常！")
  var xml = "<xml>"
  for key, val in wxdb.values:
    if utils.isNumeric(val):
      xml.add "<" & key & ">" & val & "</" & key & ">"
    else:
      xml.add "<" & key & "><![CDATA[" & val & "]]></" & key & ">"
  xml.add "</xml>"
  result = xml

method fromXml*(wxdb: WxPayDataBase,
        xml: string): OrderedTableRef[string, string] {.discardable, base.} =
  ## 由xml字符串转换为数据对象数据，返回一个有序表
  let xmlnode = parseXml(xml)
  for child in xmlnode:
    if child.kind != xnElement:
      continue
    for item in child:
      wxdb.values[child.tag] = item.text
  result = wxdb.values

method toUrlParams*(wxdb: WxPayDataBase): string {.base.} =
  ## 将数据对象数据格式化成url参数
  var buff = ""
  for k, v in wxdb.values:
    if k != "sign" and v != "": # 跳过sign签名和空值键
      buff.add k & "=" & v & "&"
    
  buff.removeSuffix('&')
  result = buff

method makeSign*(wxdb: WxPayDataBase, config: WxPayConfig,
         needSignType = true): string {.base.} =
  ## 生成并返回签名，本函数不覆盖sign成员变量，如要设置签名需要调用setSign方法赋值
  if needSignType:
    discard wxdb.setSignType(config.getSignType)

  # 签名步骤一：按字典序排序参数
  wxdb.values.sort(system.cmp)
  var s = wxdb.toUrlParams()
  # 签名步骤二：在s后加入KEY
  s.add "&key=" & config.getKey()
  # 签名步骤三：MD5加密或者HMAC-SHA256
  if config.getSignType() == "MD5":
    s = getMD5(s)
  elif config.getSignType() == "HMAC-SHA256":
    s = toHex(hmac_sha256(config.getKey(), s))
  else:
    raise newException(WxPayException, "签名类型不支持！")
  # 签名步骤四：所有字符转为大写
  result = toUpper(s)

method setSign*(wxdb: WxPayDataBase, config: WxPayConfig): string {.discardable, base.} =
  ## 设置签名，详见签名生成算法
  let sign = wxdb.makeSign(config)
  wxdb.values["sign"] = sign
  result = sign

method getValues*(wxdb: WxPayDataBase): OrderedTableRef[string, string]
    {.base.} =
  ## 获取数据对象的数据，返回一个有序表
  result = wxdb.values

method setValues*(wxdb: WxPayDataBase,
                  values: OrderedTableRef[string, string]) {.base.} =
  ## 设置数据对象数据
  wxdb.values = values

method getData*(wxdb: WxPayDataBase, key: string): string {.base.} =
  ## 获取数据对象数据指定KEY的值
  result = wxdb.values[key]

method setData*(wxdb: WxPayDataBase, key, value: string) {.base.} =
  ## 设置数据对象数据指定KEY的值
  if wxdb.values == nil:
    var t = OrderedTableRef[string, string]()
    t[key] = value
    wxdb.values = t
  else:
    wxdb.values[key] = value