# This class scans your stylesheets for pseudo classes, then inserts a new CSS
# rule with the same properties, but named 'psuedo-class-{{name}}'.
#
# Supported pseudo classes: hover, disabled, active, visited, focus.
#
# Example:
#
#   a:hover{ color:blue; }
#   => a.pseudo-class-hover{ color:blue; }
class KssStateGenerator
  constructor: ->
    pseudos = /(\.styleguide-example).*(\:hover|\:disabled|\:active|\:visited)/g

    try
      for stylesheet in document.styleSheets
        idxs = []
        for rule, idx in stylesheet.cssRules
          if (rule.type == CSSRule.STYLE_RULE) && pseudos.test(rule.selectorText)
            replaceRule = (matched, stuff) ->
              return matched.replace(/\:/g, '.pseudo-class-');
            @insertRule(rule.cssText.replace(pseudos, replaceRule))

  # Takes a given style and attaches it to the current page.
  #
  # rule - A CSS rule String (ex: ".test{ display:none; }").
  #
  # Returns nothing.
  insertRule: (rule) ->
    headEl = document.getElementsByTagName('head')[0]
    styleEl = document.createElement('style')
    styleEl.type = 'text/css'
    if styleEl.styleSheet
      styleEl.styleSheet.cssText = rule
    else
      styleEl.appendChild(document.createTextNode(rule))

    headEl.appendChild(styleEl)

$ ->
  new KssStateGenerator


################################################

class jetbrick.api.AutoDemo
  constructor: (@dom) ->
    html = @dom.find("[type=syntaxhighlighter]").html()
    html = html.between("<![CDATA[", "]]>")

    modifier = @dom.attr("data-modifier-name")
    modifier = """<span class="styleguide-modifier-name">#{modifier}</span>""" if modifier

    html = $("""
             <div class="styleguide-element clearfix">
                #{modifier || ""}
                #{html}
             </div>
           """)

    @dom.before(html)
    html.apiComponents()


################################################
$ ->
  SyntaxHighlighter.defaults.gutter = false
  SyntaxHighlighter.defaults.toolbar = false

  SyntaxHighlighter.all()





