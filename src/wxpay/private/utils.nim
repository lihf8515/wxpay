func isNumeric*(s: string, enableNaNInf, enableLooseDot = false): bool =
  ## Checks whether the string is numeric.
  ## When the string is an integer, float or exponential, it returns true,
  ## otherwise it returns false.
  ## The `enableNaNInf` value indicates whether the `NaN` and `Inf` values
  ## are valid.
  ## The `enableLooseDot` value indicates whether loose point values such as
  ## `.9` and `9.` are valid. 
  ##
  ## **Note:** The reason that `parseFloat()` is not used to achieve this is its
  ## poor performance.
  let length = s.len
  let sHigh = s.len - 1
  var eLeft, eRight, dot, e, num = false

  if length == 3:
    if (s[0] in {'i', 'I'} and s[1] in {'n', 'N'} and s[2] in {'f', 'F'}) or
       (s[0] in {'n', 'N'} and s[1] in {'a', 'A'} and s[2] in {'n', 'N'}):
      if enableNaNInf:
        return true
      else:
        return false

  if length == 4:
    if (s[0] in {'+', '-'} and s[1] in {'i', 'I'} and s[2] in {'n', 'N'} and s[3] in {'f', 'F'}) or
       (s[0] in {'+', '-'} and s[1] in {'n', 'N'} and s[2] in {'a', 'A'} and s[3] in {'n', 'N'}):
      if enableNaNInf:
        return true
      else:
        return false
  
  for i in countup(0, sHigh):
    case s[i]
    of '+', '-':
      if i == sHigh:
        return false
      if e == false:
        if num:
          return false
        if eLeft:
          return false
        eLeft = true
      else:
        if num:
          return false
        if eRight:
          return false
        eRight = true
    of '.':
      if dot:
        return false
      if not enableLooseDot:
        if num == false:
          return false
        else:
          if i == sHigh:
            return false
          if s[i+1] in {'e', 'E'}:
            return false
      num = false
      dot = true
    of 'e', 'E':
      if i == sHigh:
        return false
      if num or dot:
        if e:
          return false
        num = false
      else:
        return false
      e = true
    of '0'..'9':
      num = true
    of '_':
      if num == false:
        return false
      if dot and num == false:
        return false
      if e and num == false:
        return false
    else:
      return false

  return true