###--------------------------------------------
         api = autoSwitcher
data-trigger = mouseover / click
 data-target = #id / .class / tag
   data-show = show / slide / fade
   data-hide = none / auto
-------------------------------------------####
class $.api.autoSwitcher
    constructor: (@dom) ->
        @trigger = dom.attr('data-trigger') ? 'mouseover'
        @target = dom.attr('data-target')
        @show =  dom.attr('data-show') ? 'show'
        @hide =  dom.attr('data-hide') ? 'none'

        dom.on @trigger, =>
            $(@target).show('fast') if @show == 'show'
            $(@target).slideDown('fast') if @show == 'slide'
            $(@target).fadeIn('fast') if @show == 'fade'

        if @hide == 'auto'
            $.api.Hider.add $(@target)