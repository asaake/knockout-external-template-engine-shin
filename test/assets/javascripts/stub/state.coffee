class State
  constructor: (id, name, cities) ->
    @id = id
    @name = name
    @cities = cities || ["Dunno"]

    ko.track(@, ["id", "name", "cities"])

  afterRenderCallback: (elem, model) ->
    if($(elem).is(".loading"))
      throw new Error("afterAdd invoked but this is still the loading template")
    else
      console.log("afterAdd invoked for " + model.name + ", " + name + ".  This is the real template.")
      if $(elem).find("strong").text() == "Chattanooga"
        $(elem).find("strong").html("<a href='http://www.chattanoogafun.com/' alt='O Hai, Chattanooga' target='_blank'>Chattanooga</a>")
