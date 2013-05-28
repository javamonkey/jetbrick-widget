###--------------------------------------------------------------
 * 实现打印功能（只打印网页中的一部分）
 *
 * Usage:
 *   <button api="print" data-area="#printContext">Print</button
 *
 * @param {String} options.area           要打印的元素 (selector/dom)
 * @param {String} options.class          用来表示 area 的类型, 默认 selector
 -------------------------------------------------------------###

class jetbrick.api.Print
  constructor: (@dom, options) ->
    @options = $.extend({}, @dom.data(), options)
    @dom.on "click", (event) => @print()

  print: ->
    area = if @options.class == "dom" then eval(@options.area) else @options.area
    area = $(area)

    $("iframe.js-print").remove()
    iframe = $('<iframe class="js-print" style="position:absolute;width:0;height:0;left:-1000px;top:-1000px;">')
    iframe.appendTo(document.body)

    styles = []
    $(document).find("link[rel=stylesheet]").each ->
      href = $(@).attr("href")
      styles.push("<link type='text/css' rel='stylesheet' href='#{href}' />")
    $(document).find("style").each ->
      styles.push("<style>#{$(@).html()}</style>")

    frameWindow = iframe[0].contentWindow
    frameDocument = frameWindow.document
    frameDocument.write """
      <!DOCTYPE html>
      <html>
        <head>
          #{styles.join('')}
        </head>
        <body>
          #{area.outerHTML()}
        </body>
      </html>
    """
    frameDocument.close()
    frameWindow.close()
    frameWindow.focus()
    frameWindow.print()

