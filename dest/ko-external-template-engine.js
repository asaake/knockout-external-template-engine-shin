var ExternalTemplateSource;

ExternalTemplateSource = (function() {
  function ExternalTemplateSource(templateId, options) {
    this.options = ko.utils.extend({}, options);
    this.templateId = templateId;
    this.loaded = false;
    this.template = ko.observable(this.options.async ? this.options.loadingTemplate : void 0);
    this.template.data = {};
  }

  ExternalTemplateSource.prototype.data = function(key, value) {
    if (arguments.length === 1) {
      if (key === "precompiled") {
        this.template();
      }
      return this.template.data[key];
    } else {
      return this.template.data[key] = value;
    }
  };

  ExternalTemplateSource.prototype.text = function(value) {
    if (!this.loaded) {
      this.getTemplate();
    }
    if (arguments.length === 0) {
      return this.template();
    } else {
      this.template(value);
    }
  };

  ExternalTemplateSource.prototype.getTemplate = function() {
    var target, template;
    target = this.templateId;
    if (this.options.templateUrl != null) {
      target = "" + this.options.templateUrl + "/" + target;
    }
    template = "" + target + ".html";
    return $.ajax({
      method: "GET",
      url: template,
      async: this.options.async
    }).done((function(_this) {
      return function(data) {
        _this.data("precompiled", null);
        _this.loaded = true;
        return _this.template(data);
      };
    })(this));
  };

  ExternalTemplateSource.prototype.wrapAfterRender = function(options) {
    var origAfterRender;
    if ((options.afterRender != null) && !options.afterRender.wrapped) {
      origAfterRender = options.afterRender;
      options.afterRender = (function(_this) {
        return function() {
          if (_this.loaded) {
            return origAfterRender.apply(options, arguments);
          }
        };
      })(this);
      return options.afterRender.wrapped = true;
    }
  };

  return ExternalTemplateSource;

})();var KoExternalTemplateEngine,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

KoExternalTemplateEngine = (function(_super) {
  __extends(KoExternalTemplateEngine, _super);

  function KoExternalTemplateEngine(options) {
    var _base, _base1;
    if (options == null) {
      options = {};
    }
    this.options = options;
    if ((_base = this.options).async == null) {
      _base.async = true;
    }
    if ((_base1 = this.options).loadingTemplate == null) {
      _base1.loadingTemplate = '<div class="loading">Loading...</div>';
    }
    this.templates = {};
    this.allowTemplateRewriting = false;
  }

  KoExternalTemplateEngine.prototype.makeTemplateSource = function(template, bindingContext, options) {
    var elem, margeOptions, _base;
    if (typeof template === "string") {
      elem = document.getElementById(template);
      if (elem) {
        return new ko.templateSources.domElement(elem);
      } else {
        margeOptions = ko.utils.extend(ko.utils.extend({}, this.options), ko.utils.extend({}, options));
        if ((_base = this.templates)[template] == null) {
          _base[template] = new ExternalTemplateSource(template, margeOptions);
        }
        this.templates[template].wrapAfterRender(options);
        return this.templates[template];
      }
    } else if (template.nodeType === 1 || template.nodeType === 8) {
      return new ko.templateSources.anonymousTemplate(template);
    }
  };

  KoExternalTemplateEngine.prototype.renderTemplate = function(template, bindingContext, options) {
    var templateSource;
    templateSource = this.makeTemplateSource(template, bindingContext, options);
    return this.renderTemplateSource(templateSource, bindingContext, options);
  };

  return KoExternalTemplateEngine;

})(ko.nativeTemplateEngine);

ko.KoExternalTemplateEngine = KoExternalTemplateEngine;
;
