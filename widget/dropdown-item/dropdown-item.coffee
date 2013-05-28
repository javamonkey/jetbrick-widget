###--------------------------------------------------------------
 * 点击一个element，然后动态弹出层。
 * 如果点击页面的其他地方，自动关闭弹出层。
 * 注意：所有使用该方法弹出的层，只能同时弹出一个层。
 * 
 * Usage:
 * <div class="container">
 *   <button api="dropdown-item">Action</button>
 *   <ul class="dropdown">
 *     <li><a href="#">Action 1</a></li>
 *     <li><a href="#">Action 2</a></li>
 *   </ul>
 * </div>
 *
 * @param {String}  options.dropdown        弹出层 Selector, 默认是 parent().find(".dropdown")
 * @param {Boolean} options.toggle          click 是 show 还是 toggle, 默认是 false (show)
 * @param {String}  options.effect          show effect (default/fade/slide)
 -------------------------------------------------------------###

class jetbrick.api.DropdownItem
  constructor: (@dom, options) ->
    @options = $.extend({}, @dom.data(), options)

    if @options.dropdown
      @dropdown = $(@options.dropdown)
    else
      @dropdown = @dom.parent().find('.dropdown')
    @dropdown.hide()

    @dom.on 'click', (event) => @open()
  
  open: ->
    if @isOpened()
      if @options.toggle then @close()
    else
      $('.js-dropdown-trigger').removeClass('js-dropdown-trigger')
      $('.js-dropdown-item').removeClass('js-dropdown-item').hide()

      @dom.addClass('js-dropdown-trigger')
      @dropdown.addClass('js-dropdown-item').effectiveToggle(@options.effect, 'show')

  close: ->
    @dom.removeClass('js-dropdown-trigger')
    @dropdown.removeClass('js-dropdown-item').hide()

  isOpened: ->
    return @dropdown.is(":visible")

$ ->
  $(document).on 'click', (event) ->
    dom = $(event.srcElement || event.target)
    if dom.closest('.js-dropdown-item, .js-dropdown-trigger').length == 0
      $('.js-dropdown-trigger').removeClass('js-dropdown-trigger')
      $('.js-dropdown-item').removeClass('js-dropdown-item').hide()


