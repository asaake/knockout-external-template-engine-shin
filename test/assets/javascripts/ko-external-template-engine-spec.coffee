#= require ko-external-template-engine.coffee
#= require stub/state.coffee
#= require stub/view-model.coffee

describe "KoExternalTemplateEngine", () ->

  beforeEach () ->
    $("#body").html("")

  afterEach () ->

  applyBindings = (viewModel) ->
    html = """
        Show Edit Templates: <input type="checkbox" data-bind="checked: isEditable" />
        <ul id="tmpl" data-bind="template: { name: whichTemplateToUse, foreach: items }"></ul>
      """
    $("#body").html(html)
    ko.cleanNode($("#body")[0])
    ko.applyBindings(viewModel, $("#body")[0])

  it "afterRender is called", () ->

    viewModel = new StubViewModel()

    spies = []
    for item in viewModel.items
      spy = sinon.spy(item, "afterRenderCallback")
      spies.push(spy)

    ko.setTemplateEngine(new ko.KoExternalTemplateEngine({async: false}))
    applyBindings(viewModel)

    for i in [0..spies.length - 1]
      spy = spies[i]
      item = viewModel.items[i]
      expect(spy.callCount).to.eql(item.cities.length)

  it "acynRender", (done) ->

    viewModel = new StubViewModel()
    ko.setTemplateEngine(new ko.KoExternalTemplateEngine({async: true}))
    applyBindings(viewModel)

    expect($("#tmpl").text()).to.eql("Loading...Loading...Loading...")

    expectText =
        "\n" \
        + "    Tennessee\n" \
        + "    NashvilleChattanoogaFranklinSpring HillSignal Mountain\n" \
        + "\n" \
        + "    Georgia\n" \
        + "    AtlantaSavannahSnellvilleStone Mountain\n" \
        + "\n" \
        + "    Texas\n" \
        + "    DallasAustinHoustonSan AntonioKaty\n"
    setTimeout(() ->
      expect($("#tmpl").text()).to.eql(expectText)
      done()
    , 1000)




