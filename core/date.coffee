###---------------------------------------
* @returns {string}
 --------------------------------------###
Date::toJSON = () ->
  f = (n) -> if n < 10 then '0' + n else n

  return @getUTCFullYear()   + '-' +
       f(@getUTCMonth() + 1) + '-' +
       f(@getUTCDate())      + ' ' +
       f(@getUTCHours())     + ':' +
       f(@getUTCMinutes())   + ':' +
       f(@getUTCSeconds())



###--------------------------------------------------
 * 返回友好的时间（如:10分钟前)
 *
 * @param {String/Number/Date} date
 * @returns {String}
 -------------------------------------------------###
Date::readableDate = () ->
  date = @

  result = ''
  ct = (new Date().getTime() - date.getTime()) / 1000
  if ct < 60
    result = "刚刚"
  else if ct < 3600
    result = Math.floor(ct / 60) + "分钟前"
  else if ct < 86400 # 1 days
    result = Math.floor(ct / 3600) + "小时前"
  else if ct < 604800 # 7 days
    day = Math.floor(ct / 86400)
    result = (if (day < 2) then "昨天" else day + "天前")
  else
    result = date.toLocaleDateString()
  return result

