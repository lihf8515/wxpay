import strutils
import md5
import tables

import config
import database
export database

type
  WxPayDataBaseSignMd5* = ref object of WxPayDataBase
    ## 数据对象Md5签名类，继承自数据对象基类``WxPayDataBase``

method makeSign*(wxdbMd5: WxPayDataBaseSignMd5, config: WxPayConfig,
        needSignType = false): string =
  ## 重载数据对象基类的`makeSign`函数，
  ## 仅使用md5算法进行签名，不管配置的是什么签名方式，仅支持md5签名方式
  if needSignType:
    discard wxdbMd5.setSignType(config.getSignType)

  # 签名步骤一：按字典序排序参数
  sort(wxdbMd5.getValues(), system.cmp)
  var s = wxdbMd5.toUrlParams()
  # 签名步骤二：在s后加入KEY
  s.add "&key=" & config.getKey()
  # 签名步骤三：MD5加密或者HMAC-SHA256
  s = getMD5(s)
  # 签名步骤四：所有字符转为大写
  result = toUpper(s)
