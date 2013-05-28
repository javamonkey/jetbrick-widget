if not String::trim
  String::trim = -> _.string.trim(@)

String::clean = -> _.string.clean(@)
String::truncate = (size) -> _.string.truncate(@, size)

String::startsWith = (substr) -> _.string.startsWith(@, substr)
String::endsWith = (substr) -> _.string.endsWith(@, substr)
String::blank = -> _.string.isBlank(@)

String::before = (substr) -> _.string.strLeft(@, substr)
String::beforeLast = (substr) -> _.string.strLeftBack(@, substr)
String::after = (substr) -> _.string.strRight(@, substr)
String::afterLast = (substr) -> _.string.strRightBack(@, substr)

String::capitalize = -> _.string.capitalize(@)
String::swapCase = -> _.string.swapCase(@)
String::camelize = -> _.string.camelize(@)
String::classify = -> _.string.classify(@)
String::underscored = -> _.string.underscored(@)
String::dasherize = -> _.string.dasherize(@)

String::lpad = (length, padStr) -> _.string.lpad(@, length, padStr)
String::rpad = (length, padStr) -> _.string.rpad(@, length, padStr)

String.repeat = (count, separator) -> _.string.repeat(@, count, separator)
String.count = (substr) -> _.string.count(@, substr)

String.escapeHTML = -> _.string.escapeHTML(@)
String.unescapeHTML = -> _.string.unescapeHTML(@)
String.stripTags = (count, separator) -> _.string.repeat(@, count, separator)

###---------------------------------------------------
 * "abccba".between("a") === "bccb"
 * "abccba".between("a", "c") === "b"
 * 
 * @param {String} open
 * @param {String}close
 * @returns {String}
 --------------------------------------------------###
String::between = (open, close) ->
  close ?= open
  start = @indexOf(open)
  unless start is -1
    end = @indexOf(close, start + open.length)
    return @substring(start + open.length, end) unless end is -1
  return null

###--------------------------------------------------
 * "abcdef".bytesLength() == 6
 * "\ub4a3".bytesLength() == 2
 -------------------------------------------------###
String::bytesLength = -> @replace(/[^\x00-\xff]/g, "00").length

###--------------------------------------------------
 * Returns a unique id of the specified length, or 32 by default
 -------------------------------------------------###
jetbrick.uuid = (length=32) ->
  buf = []
  chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  i = 0
  while i < length
    buf[i] = chars.charAt(Math.floor(Math.random() * chars.length))
    i++
  return buf.join("")


