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

