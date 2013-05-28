###-----------------------------------------------------
 * 生成 namespace, 如果存在，则直接返回.
 * jetbrick.namespace("jetbrick.string") === window.jetbrick.string
 * jetbrick.namespace("jetbrick.string", root) === root.jetbrick.string
 *
 * @param {String} ns
 * @param {Object} context
 * @returns {Object}
----------------------------------------------------###
jetbrick.namespace = (ns, context) ->
  context ?= jetbrick.global || window
  for name in ns.split('.')
    ctx = context[name]
    if typeof(ctx) == 'undefined' 
      ctx = context[name] = {}
    context = ctx

  return context

###-----------------------------------------------------
 * var xmlhttp = jetbrick.tryThese(
 *   function() {return new ActiveXObject("Msxml2.XMLHTTP");},
 *   function() {return new ActiveXObject("Microsoft.XMLHTTP");},
 *   function() {return new XMLHttpRequest();}
 * );
----------------------------------------------------###
jetbrick.tryThese = () ->
  for fn in arguments
    try
      return fn()
    catch e
      
  return false

###-----------------------------------------------
 * Return the value of the (possibly nested) property of the
 * specified name, for the specified object.
 *
 * jetbrick.nestedValue(obj, 'users[0].name');
 ----------------------------------------------###
jetbrick.nestedValue = (obj, keys) ->
  return null if jetbrick.isNull(obj)
  return null if jetbrick.isNull(keys)
  if keys.indexOf(".") > 0
    key = keys.before(".")
    obj = jetbrick.nestedValue(obj, key)
    keys = keys.after(".")
    return jetbrick.nestedValue(obj, keys)
  else if keys.indexOf("[") > 0
    key = keys.before("[")
    index = keys.between("[", "]")
    obj = obj[key]
    index = jetbrick.asInt(index)
    return obj[index]
  else
    return obj[keys]


