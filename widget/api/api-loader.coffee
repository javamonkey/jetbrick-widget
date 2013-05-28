
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

