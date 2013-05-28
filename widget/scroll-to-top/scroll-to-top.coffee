###--------------------------------------------------------------
 * 实现“回到顶部”功能
 * 
 * Usage:
 * 1. <body api="scroll-to-top" ...>
 * 
 * 2. <img src="scroll-to-top.gif" title="回到顶部"
 *         api="scroll-to-top"
 *     />
 *
 * @param {Number} options.from                 滚动条至少大于 from, 才显示
 * @param {String} options.dest                 a Selector, 滚动到哪个jQuery对象，默认为空，代表顶部
 * @param {Number} options.position-right       显示位置 right
 * @param {Number} options.position-bottom      显示位置 bottom
 * @param {Number} options.duration             滚动速度
 * @param {String} options.image                默认图片
 -------------------------------------------------------------###

class jetbrick.api.ScrollToTop
  constructor: (@dom, options) ->
    @options = $.extend({}, jetbrick.api.ScrollToTop.defaults, @dom.data(), options)

    if @dom.is('body')
      @dom = $("<img src='#{@options.image}' title='回到顶部' />")
      $(document.body).append(@dom)

    @dom.css {
       display: 'none'
       position: 'fixed'
       cursor: 'pointer'
       right: @options['position-right']
       bottom: @options['position-bottom']
    }

    @show = false

    @dom.on 'click', =>
      @scrollup()
      return false

    $(window).bind 'scroll resize', =>
      @toggleHandler()

  scrollup: ->
    top = 0
    if @options.dest
      dest = $(@options.dest)
      top = if dest.length == 0 then 0 else dest.offset().top

    $(document.body).animate {scrollTop: top}, @options.duration


  toggleHandler: ->
    show = $(window).scrollTop() >= @options.from
    if show && not @show
      @dom.stop().fadeIn()
      @show = true
    if @show && not show
      @dom.stop().fadeOut()
      @show = false

# 默认参数
jetbrick.api.ScrollToTop.defaults = {
  'from': 30
  'dest': null
  'position-right': 20
  'position-bottom': 20
  'duration': 80
  'image': 'scroll-to-top.png'
}