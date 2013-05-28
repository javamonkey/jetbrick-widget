###--------------------------------------------------------------
 * flash 上传文件
 * 
 * <button api="flash-uploader">Uploader</button>
 * 
 * Events:
 *   $(document.body)
 *     .on("flash-uploader:load", callback)
 *
 *   $("[api=flash-uploader]")
 *     .on("flash:open", callback)
 *     .on("flash:select", callback)
 *     .on("flash:progress", callback)
 *     .on("flash:complete", callback)
 *     .on("flash:error", callback)
 *
 -------------------------------------------------------------###

class jetbrick.api.FlashUploader
  constructor: (@dom, options) ->
    @options = $.extend({}, @dom.data(), options)

    flash.load(@options)

    @dom.on "mouseover", =>
      flash.dom = @dom
      offset = @dom.offset()
      box = {
        left: offset.left
        top: offset.top
        width: @dom.outerWidth()
        height: @dom.outerHeight()
      }

      flash.flashContainer.css {
        left: box.left
        top: box.top
        width: box.width
        height: box.height
        zIndex: jetbrick.zIndex()
      }
      flash.flashObject.setSize(box.width, box.height)
      flash.flashObject.setHandCursor(@dom.css("cursor") == "pointer")

  hide: ->
    flash.object = null
    flash.flashContainer.css {
      left: -9999
      top: -9999
      zIndex: 0
    }

  dispatchEvent: (eventName, args) ->
    switch eventName
      when "mouseover"
        @dom.addClass("js-flash-hover")
      when "mouseout"
        @dom.removeClass("js-flash-hover")
        @dom.removeClass("js-flash-active")
        @hide()
      when "mousedown"
        @dom.addClass("js-flash-active")
        @dom.removeClass("js-flash-hover")
      when "mouseup"
        @dom.addClass("js-flash-hover")
        @dom.removeClass("js-flash-active")
      when "dataRequested"
        flash.flashObject.setRequestData(@options)
      else
        dialog.update(eventName, args)
        @dom.triggerHandler $.Event("flash-uploader:#{eventName}", args)


###--------------------------------------------------------------
 * flash helper, 负责加载 flash，以及 dispatch flash event
 -------------------------------------------------------------###
class FlashHelper
  constructor: ->
    @object = null  # 当前绑定的对象
    @flashContainer = null       
    @flashObject = null

  load: (options) ->
    return if @flashContainer

    flashName = "jetbrick-file-uploader-flash"
    @flashContainer = $("""
      <div style="position:absolute;top:-999px;left:-999px;zIndex:999;width:10px;height:10px;">
        <object type="application/x-shockwave-flash" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
                id="#{flashName}" data="#{options.movie}" width="100%" height="100%">
          <param name="movie" value="#{options.movie}" />
          <param name="allowScriptAccess" value="always" />
          <param name="scale" value="exactfit" />
          <param name="loop" value="false" />
          <param name="menu" value="false" />
          <param name="quality" value="best" />
          <param name="bgcolor" value="#ffffff" />
          <param name="wmode" value="transparent" />
          <param name="flashvars" value="#{options.flashvars}" />
          <embed src="#{options.movie}"
                 type="application/x-shockwave-flash"
                 loop="false" menu="false" quality="best" bgcolor="#ffffff" width="100%" height="100%"
                 name="#{flashName}"
                 allowScriptAccess="always"
                 allowFullScreen="false"
                 wmode="transparent" scale="exactfit"
                 pluginspage="http://www.macromedia.com/go/getflashplayer"
                 flashvars="#{options.flashvars}">
          </embed>
        </object>
      </div>
    """)

    @flashContainer.appendTo(document.body)
    @flashObject = document[flashName] || window[flashName] || @flashContainer.children()[0].lastElementChild

  dispatchEvent: (eventName, args) ->
    if eventName == "load"
      $(document.body).triggerHandler $.Event("flash-uploader:load")
    else if eventName == 'debug'
      console?.log("flash debug: " + JSON?.stringify(args))
    else
      @object && @object.dispatchEvent(eventName, args)



# singleton flash helper
flash = new FlashHelper()

# export flash.dispatchEvent
window.flash_uploader_dispatch_event = $.proxy(flash.dispatchEvent, flash)


###--------------------------------------------------------------
 * upload dialog
 -------------------------------------------------------------###
class UploadDialog
  constructor: ->
    @dialog = $('jetbrick-file-uploader-dialog');
    if (@dialog.length == 0)
      @dialog = $("""
        <div class="jetbrick-file-uploader-dialog">
          <div class="filename"></div>
          <div class="progress"><div class="bar" style="width:0%"></div></div>
          <div class="stat"></div>
        </div>
      """).hide()
      $(document.body).append(@dialog)

  update: (eventName, args) ->
    switch eventName
      when "open"
        @dialog.find(".filename").html(args.name)
        @dialog.find(".stat").html("0 KB / #{args.size}")
      when "progress"
        @dialog.find(".bar").css("width", "#{100*args.bytesLoaded/args.bytesTotal}%")
        @dialog.find(".stat").html("#{args.bytesLoaded} / #{args.bytesTotal}")
        if args.bytesLoaded == args.bytesTotal
          @dialog.find(".progress").addClass("progress-success progress-striped active")
      when "uploadCompleteData"
        return
      when "complete"
        return
      when "ioError"
        return
      when "securityError"
        return

  show: ->
    @dialog.show()

  hide: ->
    @dialog.hide()

dialog = new UploadDialog()


