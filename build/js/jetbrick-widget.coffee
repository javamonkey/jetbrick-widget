###--------------------------------------------------------
 * jetbrick widget
--------------------------------------------------------###

VERSION = '1.0'

###--------------------------------------------------------
 * jetbrick namespace
--------------------------------------------------------###

root = @

root.jetbrick = jetbrick = {
  version: VERSION
  global: root
}





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

###---------------------------------------------------------
 * summary:
 *		Performs parameterized substitutions on a string. Throws an
 *		exception if any parameter is unmatched.
 * template:
 *		a string with expressions in the form `{key}` to be replaced.
 *      keys are case-sensitive.
 * data:
 *		hash to search for substitutions
 * transform:
 *		a function to process all parameters before substitution takes
 *		place, e.g. mylib.encodeXML
 * example:
 *		Substitutes two expressions in a string from an Array or Object
 *	|	// returns "File 'foo.html' is not found in directory '/temp'."
 *	|	// by providing substitution data in an Array
 *	|	string.substitute(
 *	|		"File '{[0]}' is not found in directory '{[1]}'.",
 *	|		["foo.html","/temp"]
 *	|	);
 *	|
 *	|	// also returns "File 'foo.html' is not found in directory '/temp'."
 *	|	// but provides substitution data in an Object structure.  Dotted
 *	|	// notation may be used to traverse the structure.
 *	|	string.substitute(
 *	|		"File '{name}' is not found in directory '{info.dir}'.",
 *	|		{ name: "foo.html", info: { dir: "/temp" } }
 *	|	);
 * example:
 *		Use a transform function to modify the values:
 *	|	// returns "file 'foo.html' is not found in directory '/temp'."
 *	|	string.substitute(
 *	|		"{data[0]} is not found in {data[1].info.dir}.",
 *	|		{ data: ["foo.html", info: { dir: "/temp" }] },
 *	|		function(str){
 *	|			// try to figure out the type
 *	|			var prefix = (str.charAt(0) == "/") ? "directory": "file";
 *	|			return prefix + " '" + str + "'";
 *	|		}
 *	|	);
 --------------------------------------------------------###
jetbrick.substitute = (template, data, transform) ->
  regex = /\{([^{}]+)\}/g
  _.isFunction(transform) or (transform = (v) -> v)

  template.replace regex, (match, key) ->
    value = jetbrick.nestedValue(data, key)
    value ?= ""
    return transform(value)

###--------------------------------------------------------
 * A underscore template
 -------------------------------------------------------###
jetbrick.usTemplate = (templateString, data) ->
  settings = {
    evaluate    : /`([\s\S]+?)`/g
    interpolate : /\{([\s\S]+?)\}/g
    escape      : /@\{([\s\S]+?)\}/g
  }
  return _.template(templateString, data, settings)



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




###--------------------------------------------------------
 * jetbrick api namespace
--------------------------------------------------------###
jetbrick.api = {}

###--------------------------------------------------------
 * 自动初始化所有绑定的 api 组件
 * 并返回第一个 dom 对应的 apiName 的 Component object
 * 
 * Usage:
 *   <tag api="widget-1,widget-2" ... />
 *   obj1 = $('tag').apiComponents()
 *   obj2 = $('tag').apiComponents('widget-2')
 *
 * @param {String} apiName 要返回的 apiName
 * @return {Object} return object instance
 -------------------------------------------------------###
# const
API_NAME = "api"
API_SELECTOR = "[#{API_NAME}]"
API_DATA_KEY = "DEFAULT-API-KEY"

$.fn.apiComponents = (apiName) ->
  @each ->
    dom = $(@)
    apiNames = dom.attr(API_NAME)
    if apiNames
      for apiName in apiNames.split(',')
        apiName = $.trim(apiName).camelize().capitalize()
        apiClass = jetbrick.api[apiName]
        throw new Error("component is not available: #{apiName}") if not apiClass
        throw new Error("jetbrick.api.#{apiName} is not a Javascript Class") if not $.isFunction(apiClass)

        if not dom.data(apiName)
          obj = new apiClass(dom)
          dom.data(apiName, obj)
          dom.data(API_DATA_KEY, obj) if not dom.data(API_DATA_KEY)
      return
    else
      dom.find(API_SELECTOR).apiComponents()

  # return Component object
  apiName ?= API_DATA_KEY
  return @data(apiName)


# document.ready, 自动加载所有的 api 组件
$ -> $(API_SELECTOR).apiComponents()


jetbrick.webroot = ->
  return jetbrick.webroot.cache if jetbrick.webroot.cache

  path = "."
  $("script[src*=jetbrick]").each ->
    s = @src
    if s.endsWith(".js")
      path = s.beforeLast(s, "/")
      return false

  path = path.beforeLast("/js") if path.endsWith("/js")
  path = path.beforeLast(path, "/share") if path.endsWith("/share")
  path = path.beforeLast(path, "/static") if path.endsWith("/static")
  return jetbrick.webroot.cache = path

###--------------------------------------------------------
 * @param {String} effect              default/fade/slide
 * @param {String} toggle              show/hide/toggle
 * @param {String/Number} duration     default is 400
 * @param {Function} complete          callback function when completed
 * @see jQuery Effects: http://api.jquery.com/category/effects/
 -------------------------------------------------------###
$.fn.effectiveToggle = (effect, toggle, duration, complete) ->
  effect ?= "default"
  if effect == "default"
    fn = toggle
  else if effect == "fade"
    fn = "fadeIn" if toggle == "show"
    fn = "fadeOut" if toggle == "hide"
    fn = "fadeToggle" if toggle == "toggle"
  else if effect == "slide"
    fn = "slideDown" if toggle == "show"
    fn = "slideUp" if toggle == "hide"
    fn = "slideToggle" if toggle == "toggle"

  $.fn[fn].call(this, duration, complete)

###--------------------------------------------------------
 * jQuery.fn.outerHTML
 -------------------------------------------------------###
$.fn.outerHTML = ->
  return "" if @length == 0

  dom = @[0]

  html = dom.outerHTML
  return html if html

  tagName = dom.tagName.toLowerCase()
  html = "<" + tagName;
  for attribute in dom.attributes
    name = attribute.nodeName
    value = attribute.nodeValue
    value = value.replace("'", "\\'") if value
    html += " #{name}='#{value}'"

  html += ">#{@html()}</#{tagName}>"


###--------------------------------------------------------
 * 获取整个document最大可用的 zIndex
 *
 * @returns {Number}
 -------------------------------------------------------###
jetbrick.zIndex = ->
  nodes = document.getElementsByTagName("*")
  max = 0
  for node in nodes
    zIndex = (+node.style.zIndex) || 0
    max = zIndex if max < zIndex

  return max + 1

###--------------------------------------------------------
 * 添加 name=value 到 URL 的 QueryString 中.
 * ("index.html", "id", 1) === "index.html?id=1"
 * ("index.html?id=1", "name", "jack") === "index.html?id=1&name=jack"
 *
 * @param {String} url
 * @param {String} name
 * @param {*} value
 * @returns {String}
 -------------------------------------------------------###
jetbrick.addQueryString = (url, name, value) ->
  url += if url.indexOf("?") < 0  then "?" else "&"
  url += name + "=" + jetbrick.asString(value)
  return url


###--------------------------------------------------------
 * @param {String} url
 * @param {String} target     default is "_self"
 -------------------------------------------------------###
jetbrick.redirectUrl = (url, target) ->
  url = jetbrick.addQueryString(url, "_", Math.random())
  window.open(url, target || "_self", null, true)




###-------------------------------------------------------------
 * 实现INPUT只能输入数字和小数点
 *
 * Usage:
 *   <input api="numeric-input" data-decimal="false" />
-------------------------------------------------------------###

class jetbrick.api.NumericInput
  constructor: (@dom, options) ->
    @options = $.extend({}, @dom.data(), options)

    @dom.css "ime-mode", "disabled"

    @dom.on "keypress", (e) ->
      code = e.which
      return code >= 48 and code <= 57 or code == 46

    @dom.on "blur", ->
      if @value.lastIndexOf(".") == (@value.length - 1)
        @value = @value.substr(0, @value.length - 1)
      else
        @value = "" if isNaN(@value)

    @dom.on "paste", ->
      s = clipboardData.getData("text")
      @value = s.replace(/^0*/, "") if /\D/.test(s)
      return false

    @dom.on "dragenter", -> return false

    @dom.on "drop", -> return false

    @dom.on "keyup", (e) ->
      # HOME, END, UP, DOWN, LEFT, RIGHT
      return true if 35 <= e.which <= 40

      s = @value
      s = s.replace(/[^\d.]/g, "")
      #必须保证第一个为数字而不是.
      s = s.replace(/^\./g, "")
      #保证只有出现一个.而没有多个.
      s = s.replace(/\.{2,}/g, ".")
      #保证.只出现一次，而不能出现两次以上
      s = s.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".")

      @value = s


class LockSprite
  constructor: ->
    @dialogs = []
    @mask = $('<div class="js-lock" />').css {
      'display': 'none'
      'position': 'fixed'
      'width': '100%'
      'height': '100%'
      'left': 0
      'top': 0
      'background-color': '#000'
    }
    $(document.body).append(@mask)

  lock: (zIndex, opacity, duration, callback) ->
    @mask.css {
      'opacity': opacity || 0.4
      'z-index': zIndex
    }
    if duration
      @mask.fadeIn(duration, callback)
    else
      @mask.show()

  unlock: -> @mask.hide()

  push: (dialog) ->
    @dialogs.push {
      name: dialog
      zIndex: jetbrick.zIndex()
    }
    @lock(item.zIndex)

  pop: (dialog) ->
    @dialogs = _.reject @dialogs, (item) -> item.name == dialog

    if @dialogs.length == 0
      @unlock()
    else
      @lock(@dialogs[@dialogs.length-1].zIndex)


# singleton
lockSprite = new LockSprite()

########################################################

class LoadingSprite
  constructor: ->
    image = jetbrick.webroot() + '/static/images/widget/ajax-loading.gif'
    html = """
      <div class="js-ajax-loading">
        <img src="#{image}" style="vertical-align:middle" />
        <span style="padding:0 12px">正在请求服务器，请稍后 ...</span>
        <a href="javascript:;">(X)</a>
      </div>"""

    @loading = $(html).css {
      'position': 'fixed'
      'dispaly': 'block'
      'width': 'auto'
      'left': '50%'
      'top': '38%'  # 50%

      'font-size': '14px'
      'border': '6px solid #555'
      'background-color': '#fff'
      'padding': '15px 20px'

      '-webkit-border-radius': '5px'
      '-moz-border-radius':'5px'
      'border-radius': '5px'
      '-webkit-box-shadow': '0 1px 10px rgba(0, 0, 0, 0.4)'
      '-moz-box-shadow': '0 1px 10px rgba(0, 0, 0, 0.4)'
      'box-shadow': '0 1px 10px rgba(0, 0, 0, 0.4)'
    }
    $(document.body).append(@loading)

    @loading.find('a').on('click', $.proxy(@hide, @))


  show: ->
    lockSprite.push('loadingSprite')
    @loading.css {
      'margin-left': 0 - this.$loading.outerWidth() / 2
      'margin-top': 0 - this.$loading.outerHeight() / 2
      'z-index': jetbrick.zIndex()
    }
    @loading.show()

  hide: (unlock) -> 
    @loading.hide()
    lockSprite.pop('loadingSprite') if unlock


# singleton
loadingSprite = new LoadingSprite()


########################################################

jetbrick.ajax = (url, params, callback, method, dataType) ->
  loadingSprite.show()

  $.ajax {
    global: false
    cache: false
    async: true
    type: method || 'GET'
    url: url
    data: params
    dataType: dataType || 'json'
    success: ->
      loadingSprite.hide(false)
      callback.apply(this, arguments) if callback
      loadingSprite.hide(true)
    error: ->
      loadingSprite.hide(false)
      jetbrick.error('服务请求失败，请联系管理员或者稍后重试。')
      loadingSprite.hide(true)
  }

jetbrick.dialog = (title, content, callback) ->
  id = _.uniqueId('dialog_')
  lockSprite.push(id)

  return art.dialog {
    id: id
    fixed: true
    lock: false
    title: title
    content: content
    zIndex: jetbrick.zIndex()

    initialize: callback?.initialize
    ok: callback?.ok
    cancel: callback?.cancel
    beforeunload: ->
      callback?.beforeunload?.apply(@, arguments)
      lockSprite.pop(name)
  }

message_box = (icon, title, content, yes_fn, no_fn) ->
  #<span style="float:left; background-image:url(info.png); width:48px; height:48px; margin-right:14px;"></span>
  content = """
    <span class="js-dialog-icon js-dialog-icon-#{icon}"></span>
    <span>#{content}</span>
  """
  if $.isFunction(yes_fn) then yes_fn = -> yes_fn.apply(@, arguments) 
  if $.isFunction(no_fn)  then no_fn = -> no_fn.apply(@, arguments) 

  jetbrick.dialog title, content, {
    ok: yes_fn
    cancel: no_fn
  }

jetbrick.info    = (content, callback) -> message_box('info',    '消息', content, callback || true)
jetbrick.warning = (content, callback) -> message_box('warning', '警告', content, callback || true)
jetbrick.error   = (content, callback) -> message_box('error',   '错误', content, callback || true)
jetbrick.confirm = (content, yes_fn, no_fn) -> message_box('question','确认', content, yes_fn || true, no_fn || true)

jetbrick.alert = (succ, content, callback) -> if succ then jetbrick.info(content, callback) else jetbrick.error(content, callback)

jetbrick.prompt = (content, yes_fn, value) ->
  value ?= ""
  content = $("""
    <div style="margin-bottom:5px;font-size:12px;">#{content}</div>
    <div><input value="#{value}" style="width:18em;padding:6px 4px;"></div>
  """)
  message_box 'question', '提问', content, ->
    input = content.find('input')
    yes_fn?.call(@, input.val())


