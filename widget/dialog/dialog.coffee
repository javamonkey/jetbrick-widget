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

