class StubViewModel

  constructor: () ->
    @isEditable = false
    @items = [
      new State(1, "Tennessee", [
          {name: "Nashville"}, {name: "Chattanooga"}, {name: "Franklin"}, {name: "Spring Hill"}, {name: "Signal Mountain"}
      ]),
      new State(2, "Georgia", [
          {name: "Atlanta"}, {name: "Savannah"}, {name: "Snellville"}, {name: "Stone Mountain"}
      ]),
      new State(3, "Texas", [
          {name: "Dallas"}, {name: "Austin"}, {name: "Houston"}, {name: "San Antonio"}, {name: "Katy"}
      ])
    ]
    ko.track(@, ["isEditable", "items"])

  whichTemplateToUse: () =>
    return if @isEditable then "/stub/edit" else "/stub/view"