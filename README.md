# knockout-external-template-engine-shin

* required
  * knockout.js <= 3.0
  * jquery.js <= 2.0
  * sugar.js <= 1.4

```coffee
# usage
# = require ko-external-template-engine.js
viewModel = new StubViewModel()
ko.setTemplateEngine(new ko.KoExternalTemplateEngine({
  async: true
  loadingTemplate: '<div class="loading">Loading...</div>'
}))
ko.applyBindings(viewModel)
```


```
# example setup and view
sudo npm install -g easy-mincer
git clone https://github.com/asaake/knockout-external-template-engine-shin.git
cd knockout-external-template-engine-shin
npm install
bower install
cd bower_components/knockout
npm install
grunt
cd ../../
easy-mincer start

#=> access to [http://localhost:3000/index.html]
