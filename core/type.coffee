###----------------------------------------------------
 * isNull === null || undefined
 *
 * @param {*} obj
 * @return {Boolean}
 ---------------------------------------------------###
jetbrick.isNull = (obj) -> (obj is null) or (obj is undefined)


###----------------------------------------------------
 * isNotNull === not null && not undefined
 *
 * @param {*} obj
 * @return {Boolean}
 ---------------------------------------------------###
jetbrick.isNotNull = (obj) -> not jetbrick.isNull(obj)


###----------------------------------------------------
 * convert to object to string if not null
 *
 * (null / undefined) === null
 * 
 * @param {*} obj
 * @returns {String}
 ---------------------------------------------------###
jetbrick.asString = (obj) ->
  return null if jetbrick.isNull(obj)
  return obj.toString()


###----------------------------------------------------
 * convert to object to float if not null
 *
 * (null / undefined) === null
 * ("1234.5678", 2) === 1234.56
 * 
 * @param {*} obj
 * @param {Integer} precision
 * @returns {Float}
 ---------------------------------------------------###
jetbrick.asFloat = (obj, precision) ->
  return null if jetbrick.isNull(obj)
  return obj if _.isNumber(obj)
  num = parseFloat(obj.toString(), 10)
  num = parseFloat(num.toFixed(precision)) if precision
  return num


###----------------------------------------------------
 * convert to object to integer if not null.
 * If the string starts with '0x' or '-0x', parse as hex.
 *
 * (null / undefined) === null
 * ("1234") === 1234
 * ("0xFF") === 255
 * 
 * @param {*} obj
 * @returns {Integer}
 ---------------------------------------------------###
jetbrick.asInt = (obj) ->
  return null if jetbrick.isNull(obj)
  return obj.toFixed(0) if _.isNumber(obj)

  # If the string starts with '0x' or '-0x', parse as hex.
  str = obj.toString()
  return (if /^\s*-?0x/i.test(str) then parseInt(str, 16) else parseInt(str, 10))


###----------------------------------------------------
 * Parses the object argument as a boolean.
 *
 * (null, undefined) === false
 * (true, yes, on, y, t, 1) === true
 * 
 * @param {*} obj
 * @returns {Boolean}
 ---------------------------------------------------###
jetbrick.asBoolean = (obj) ->
  return false if jetbrick.isNull(obj)
  return obj if _.isBoolean(obj)
  if _.isString(obj)
    s = obj.toString().toLowerCase()
    return s is "true" or
           s is "yes" or
           s is "on" or
           s is "t" or
           s is "y" or
           s is "1"
  return !!obj


###----------------------------------------------------
 * @required date-js
 *
 * ("2012-01-01 12:00:00") === new Date(2012-01-01 12:00:00)
 * 
 * @param {*} obj
 * @returns {Date}
 ---------------------------------------------------###
jetbrick.asDate = (obj) ->
  return null if jetbrick.isNull(obj)
  return obj if _.isDate(obj)
  return new Date(obj) if _.isNumber(obj)
  return Date.parseExact(obj.toString(), jetbrick.asDate.DATE_FORMATER_LIST)

jetbrick.asDate.DATE_FORMATER_LIST = [
  "yyyy-MM-dd HH:mm:ss"
  "yyyy-MM-dd"
  "HH:mm:ss"
]

###----------------------------------------------------
 * ("object.func", window) === window.object.func
 * 
 * @param {*} fn
 * @param {*} context
 * @returns {Function}
 ---------------------------------------------------###
jetbrick.asFunction = (fn, context) ->
  return null if jetbrick.isNull(fn)
  return fn if _.isFunction(fn)
  if context
    f = jetbrick.get(context, fn)
    return f if _.isFunction(f)
  f = jetbrick.get(jetbrick.global, fn)
  return f if _.isFunction(f)
  return null


###----------------------------------------------------
 * ("[{id:1},{id,2}]") === [{id:1},{id,2}]
 * 
 * @required JSON2.js
 * @param {String} str
 * @returns {*}
 ---------------------------------------------------###
jetbrick.asJSON = (str) ->
  return null if jetbrick.isNull(str)
  return JSON.parse(str) if _.isString(str)
  return str
