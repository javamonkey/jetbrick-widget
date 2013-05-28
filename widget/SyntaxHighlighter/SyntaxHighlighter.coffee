###-------------------------------------------------------------
 * 封装 SyntaxHighlighter 组件
 *
 * Usage:
 *   <pre api="syntax-highlighter" data-language="java">
 *       ...
 *   </pre>
-------------------------------------------------------------###

class jetbrick.api.SyntaxHighlighter
  constructor: (@dom, options) ->
    @options = $.extend({}, @dom.data(), options)
