###--------------------------------------------
         api = formValidator
data-trigger = mouseover / click
 data-target = #id / .class / tag
   data-show = show / slide / fade
   data-hide = none / auto
-------------------------------------------####

INPUTS_SELECTOR = 'input,textarea,select'

class $.api.formValidator
    constructor: (@form) ->
        @errors = []
        form.on 'submit', =>
            form.find(INPUTS_SELECTOR).each ->
                f = $(@).getApiObject()
                f.validate()

    error: ->
        return @errors.length > 0

    reset: ->
        @form.find(INPUTS_SELECTOR).each ->
            f = $(@).getApiObject()
            f.reset()


###--------------------------------------------
         api = fieldValidator
data-postion = #id / .class / tag
data-message = an error message
-------------------------------------------####
class $.api.fieldValidator
    constructor: (@input) ->
        @position = input.attr('data-postion')
        @message = input.attr('data-message')

    validate: ->

    error: ->

    reset: ->