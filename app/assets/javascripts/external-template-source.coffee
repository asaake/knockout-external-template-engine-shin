class ExternalTemplateSource

  constructor: (templateId, options) ->
    @options = ko.utils.extend({}, options)
    @templateId = templateId
    @loaded = false
    @template = ko.observable(if @options.async then @options.loadingTemplate else undefined)
    @template.data = {}

  data: (key, value) ->
      if arguments.length == 1
        if key == "precompiled"
          @template()
        return @template.data[key]
      else
        @template.data[key] = value

  text: (value) ->
      if not @loaded
        @getTemplate()

      if arguments.length == 0
        return @template()
      else
        @template(value)
        return

  getTemplate: () ->
    target = @templateId
    if @options.templateUrl?
      target = "#{@options.templateUrl}/#{target}"
    template = "#{target}.html"
    $.ajax({
      method: "GET"
      url: template
      async: @options.async
    }).done (data) =>
      @data("precompiled", null)
      @loaded = true
      @template(data)

  wrapAfterRender: (options) ->
    if options.afterRender? && not(options.afterRender.wrapped)
      origAfterRender = options.afterRender
      options.afterRender = () =>
        if @loaded
          origAfterRender.apply(options, arguments)
      options.afterRender.wrapped = true