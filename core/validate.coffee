###--------------------------------------------------
 * Checks whether the String is all number [0-9]+.
 -------------------------------------------------###
String::isNumeric = () -> /^[0-9]+$/.test(@)


###--------------------------------------------------
 * Checks whether the String is all alpha [a-zA-Z]+.
 -------------------------------------------------###
String::isAlpha = () -> /^[a-zA-Z]+$/.test(@)


###--------------------------------------------------
 * Checks whether the String is all number [a-zA-Z0-9]+.
 -------------------------------------------------###
String::isAlphaNumeric = () -> /^[a-zA-Z0-9]+$/.test(@)


###--------------------------------------------------
 * Checks whether the String is IP address.
 -------------------------------------------------###
String::isIPAddress = () ->
  ip = @
  re = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/
  ret = re.test(ip)
  return false unless ret
  arr = ip.split(".")
  i = 0

  while i < 4
    arr[i] = parseInt(arr[i], 10)
    return false if arr[i] > 255
    i++
  return true


###--------------------------------------------------
 * Checks whether the String is EMAIL address.
 -------------------------------------------------###
String::isEmail = () -> /^[A-Z0-9._-]+@[A-Z0-9.-]+.[A-Z]{2,4}$/i.test(@)


###--------------------------------------------------
 * Checks whether the String a valid Java Integer number.
 -------------------------------------------------###
String::isInteger = (radix=10) ->
  s = @
  n = parseInt(s, radix)
  return not isNaN(n) and n.toString() is s


###--------------------------------------------------
 * Checks whether the String a valid Java Float number.
 -------------------------------------------------###
String::isFloat = () ->
  s = str = @
  f = parseFloat(s)
  unless isNaN(f)
    str = f.toString()
    if str.indexOf(".") > -1
      str = str.rpad(s.length, "0")
    else if s.length > str.length
      str = str + ".0"
      str = str.rpad(s.length, "0")
    return str.toString() is s.toString()
  else
    return false


