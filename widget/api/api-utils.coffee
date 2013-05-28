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



