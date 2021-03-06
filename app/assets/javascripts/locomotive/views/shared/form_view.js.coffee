Locomotive.Views.Shared ||= {}

class Locomotive.Views.Shared.FormView extends Backbone.View

  el: '.main'

  namespace: null

  inputs: []

  events:
    'submit form': 'save'

  render: ->
    @display_active_nav()

    @enable_file_inputs()
    @enable_array_inputs()
    @enable_toggle_inputs()
    @enable_date_inputs()
    @enable_datetime_inputs()
    @enable_rte_inputs()
    @enable_tags_inputs()
    @enable_document_picker_inputs()

    # make title editable (if possible)
    # @make_title_editable()

    # @_hide_last_separator()

    # make inputs foldable (if specified)
    # @make_inputs_foldable()

    # TODO: allow users to save with CTRL+S or CMD+s
    # @enable_save_with_keys_combination()

    # enable form notifications
    # @enable_form_notifications()

    return @

  display_active_nav: ->
    url = document.location.toString()
    if url.match('#')
      name = url.split('#')[1]
      @$(".nav-tabs a[href='##{name}']").tab('show')

  record_active_tab: ->
    tab_name = $('form .nav-tabs li.active a').attr('href').replace('#', '')
    @$('#active_tab').val(tab_name)

  change_state: ->
    @$('form button[type=submit]').button('loading')

  save: (event) ->
    @change_state()
    @record_active_tab()

  enable_file_inputs: ->
    self = @
    @$('.input.file').each ->
      view = new Locomotive.Views.Inputs.FileView(el: $(@))
      view.render()
      self.inputs.push(view)

  enable_array_inputs: ->
    self = @
    @$('.input.array').each ->
      view = new Locomotive.Views.Inputs.ArrayView(el: $(@))
      view.render()
      self.inputs.push(view)

  enable_toggle_inputs: ->
    @$('.input.toggle input[type=checkbox]').each ->
      $toggle = $(@)
      $toggle.data('label-text', (if $toggle.is(':checked') then $toggle.data('off-text') else $toggle.data('on-text')))
      $toggle.bootstrapSwitch
        onSwitchChange: (event, state) ->
          $toggle.data('bootstrap-switch').labelText((if state then $toggle.data('off-text') else $toggle.data('on-text')))

  enable_date_inputs: ->
    @$('.input.date input[type=text]').each ->
      $(@).datetimepicker
        language: window.content_locale
        pickTime: false
        widgetParent: '.main'
        format: $(@).data('format')

  enable_datetime_inputs: ->
    @$('.input.date-time input[type=text]').each ->
      $(@).datetimepicker
        language: window.content_locale
        pickTime: true
        widgetParent: '.main'
        use24hours: true
        useseconds: false
        format: $(@).data('format')

  enable_rte_inputs: ->
    self = @
    @$('.input.rte').each ->
      view = new Locomotive.Views.Inputs.RteView(el: $(@))
      view.render()
      self.inputs.push(view)

  enable_tags_inputs: ->
    @$('.input.tags input[type=text]').tagsinput()

  enable_document_picker_inputs: ->
    self = @
    @$('.input.document_picker').each ->
      view = new Locomotive.Views.Inputs.DocumentPickerView(el: $(@))
      view.render()
      self.inputs.push(view)

  remove: ->
    _.each @inputs.each, (view) -> view.remove()
    @$('.input.tags input[type=text]').tagsinput('destroy')

  _stop_event: (event) ->
    event.stopPropagation() & event.preventDefault()


  # ===============================

  # save: (event) ->
  #   alert('foo')
  #   by default, follow the default behaviour

  # save_in_ajax: (event, options) ->
  #   event.stopPropagation() & event.preventDefault()

  #   @trigger_change_event_on_focused_inputs()

  #   form = $(event.target).trigger('ajax:beforeSend')

  #   @clear_errors()

  #   options ||= { headers: {}, on_success: null, on_error: null }

  #   previous_attributes = _.clone @model.attributes

  #   xhr = @model.save {},
  #     headers:  options.headers
  #     silent:   true # since we pass an empty hash above, no need to trigger the callbacks

  #   xhr.success (model, response, _options) =>
  #     form.trigger('ajax:complete')

  #     @model.set(previous_attributes)
  #     model.attributes = previous_attributes

  #     options.on_success(model, xhr) if options.on_success

  #   xhr.error (model, xhr) =>
  #     form.trigger('ajax:complete')

  #     errors = JSON.parse(model.responseText)

  #     @show_errors errors

  #     options.on_error() if options.on_error

  # make_title_editable: ->
  #   title = @$('h2 a.editable')

  #   if title.size() > 0
  #     target = @$("##{title.attr('rel')}")
  #     target.parent().hide()

  #     title.click (event) =>
  #       event.stopPropagation() & event.preventDefault()
  #       newValue = prompt(title.attr('title'), title.html());
  #       if newValue && newValue != ''
  #         title.html(newValue)
  #         target.val(newValue).trigger('change')

  # make_inputs_foldable: ->
  #   self = @
  #   @$('.formtastic fieldset.foldable.folded ol').hide()
  #   @$('.formtastic fieldset.foldable legend').click ->
  #     parent  = $(@).parent()
  #     content = $(@).next()

  #     if parent.hasClass 'folded'
  #       parent.removeClass 'folded'
  #       content.slideDown 100, -> self.after_inputs_fold(parent)
  #     else
  #       content.slideUp 100, -> parent.addClass('folded')

  # trigger_change_event_on_focused_inputs: ->
  #   # make sure that the current text field gets saved too
  #   input = @$('form input[type=text]:focus, form input[type=password]:focus, form input[type=number]:focus, form textarea:focus')
  #   input.trigger('change') if input.size() > 0

  # enable_save_with_keys_combination: ->
  #   $.cmd 'S', (() =>
  #     @$('form input[type=submit]').trigger('click')
  #   ), [], ignoreCase: true

  # enable_form_notifications: ->
  #   @$('form').formSubmitNotification()

  # after_inputs_fold: ->
  #   # overide this method if necessary

  # clear_errors: ->
  #   @$('.inline-errors').remove()

  # show_errors: (errors) ->
  #   for attribute, message of errors
  #     if _.isString(message[0])
  #       html = $("<div class=\"inline-errors\"><p>#{message[0]}</p></div>")
  #       @show_error attribute, message[0], html
  #     else
  #       @show_error attribute, message

  # show_error: (attribute, message, html) ->
  #   prefix = if @namespace? then "#{@namespace}_" else ''

  #   input = @$("##{prefix}#{@model.paramRoot}_#{attribute}")
  #   input = @$("##{prefix}#{@model.paramRoot}_#{attribute}_id") if input.size() == 0
  #   input = @$("##{prefix}#{@model.paramRoot}_#{attribute}_ids") if input.size() == 0

  #   return unless input.size() > 0

  #   anchor = input.parent().find('.error-anchor')
  #   anchor = input if anchor.size() == 0
  #   anchor.after(html)

  # _enable_checkbox: (name, options) ->
  #   options     ||= {}
  #   model_name  = options.model_name || @model.paramRoot

  #   @$("li##{model_name}_#{name}_input input[type=checkbox]").checkToggle
  #     on_callback: =>
  #       _.each options.features, (exp) -> @$("li##{model_name}_#{exp}_input").hide()
  #       options.on_callback() if options.on_callback?
  #       @_hide_last_separator()
  #     off_callback: =>
  #       _.each options.features, (exp) -> @$("li##{model_name}_#{exp}_input").show()
  #       options.off_callback() if options.off_callback?
  #       @_hide_last_separator()

  # _hide_last_separator: ->
  #   _.each @$('fieldset'), (fieldset) =>
  #     $(fieldset).find('li.last').removeClass('last')
  #     $(_.last($(fieldset).find('li.input:visible'))).addClass('last')

  # enable_form_notifications: ->
  #   @$('form').formSubmitNotification()
