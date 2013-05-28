###--------------------------------------------------
 * "12".pad(5) = 00012
 -------------------------------------------------###
Number::pad = (width) ->
  _.string.lpad(@toString(), width, '0')

###--------------------------------------------------
 * "0.1234".format() = 0.12
 * "12".format() = 12.00
 * "1234.5678".format() = 1,234.57
 * "1234.5678".format(3, false) = 1234.568
 -------------------------------------------------###
Number::format = (precision=2, commaDelimiters=true) ->
  s = if commaDelimiters then ',' else ''
  _.string.numberFormat(@, precision, '.', s)

###--------------------------------------------------
 * Compare this between min value and max value.
 -------------------------------------------------###
jetbrick.isInNumberRange = (num, min, max) ->
  return num >= min and num <= max


###--------------------------------------------------
 * 1234.readableSize() = '1.21KB'
 * 1234.readableSize(1) = '1.2KB'
 -------------------------------------------------###
Number::readableSize = (precision=2) ->
  size = Math.floor(@)
  return size.toString() + "Byte" if size < 1024
  return (size / 1024).format(precision) + "KB" if size < 1024 * 1024
  return (size / 1024 / 1024).format(precision) + "MB" if size < 1024 * 1024 * 1024
  return (size / 1024 / 1024 / 1024).format(precision) + "GB" if size < 1024 * 1024 * 1024 * 1024


###--------------------------------------------------
 * 1234.readableTime() = '00:00:01,234'
 * 1234.readableTime(false) = '00:00:01'
 -------------------------------------------------###
Number::readableTime = (showMills=false) ->
  time = @
  hh = Math.floor(time / 3600000)
  mm = Math.floor((time - hh * 3600000) / 60000)
  ss = Math.floor((time - hh * 3600000 - mm * 60000) / 1000)
  str = hh.pad(2) + ":" + mm.pad(2) + ":" + ss.pad(2)
  if showMills
    ms = Math.floor(time % 1000)
    str += "," + ms.pad(3)
  return str


###--------------------------------------------------
 * 1234567890.readableSeconds() = '14day 6hour 56minite 8second'
 * 1234.readableSeconds(2) = '14day 6hour 56minite 7.89second'
 -------------------------------------------------###
Number::readableSeconds = (secondsPrecision=0) ->
  time = @
  dd = Math.floor(time / 86400000)
  hh = Math.floor((time - dd * 86400000) / 3600000)
  mm = Math.floor((time - dd * 86400000 - hh * 3600000) / 60000)
  ss = (time - dd * 86400000 - hh * 3600000 - mm * 60000) / 1000.0
  chs = []
  chs.push dd, "天" if dd > 0
  chs.push hh, "小时" if hh > 0
  chs.push mm, "分" if mm > 0
  chs.push ss.format(secondsPrecision), "秒"
  return chs.join("")

