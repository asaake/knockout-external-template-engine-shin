class KoExternalTemplateEngine extends ko.nativeTemplateEngine

    # options.async = true | false
    # options.loadingTemplate = <div>loading...</div>
    constructor: (options={}) ->
      @options = options
      @options.async ?= true
      @options.loadingTemplate ?= '<div class="loading">Loading...</div>'
      @templates = {};
      @allowTemplateRewriting = false

    makeTemplateSource: (template, bindingContext, options) ->
      # Named template
      if typeof template == "string"
        elem = document.getElementById(template)
        if elem
          return new ko.templateSources.domElement(elem);
        else
          margeOptions = ko.utils.extend(ko.utils.extend({}, @options), ko.utils.extend({}, options))
          @templates[template] ?= new ExternalTemplateSource(template, margeOptions)
          @templates[template].wrapAfterRender(options)
          return @templates[template]
      else if template.nodeType == 1 || template.nodeType == 8
        # Anonymous template
        return new ko.templateSources.anonymousTemplate(template)

    renderTemplate: (template, bindingContext, options) ->
      templateSource = @makeTemplateSource(template, bindingContext, options)
      return @renderTemplateSource(templateSource, bindingContext, options)

ko.KoExternalTemplateEngine = KoExternalTemplateEngine
