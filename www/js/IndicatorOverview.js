var indicatorOverviewBinding = new Shiny.InputBinding();
$.extend(indicatorOverviewBinding, {
  find: function(scope) {
    return $(scope).find(".indicator-overview-binding");
  },
  getValue: function(el) {
    if(!$(el).data().indicator){
      return null;
    }
    dat = $(el).data();
    $(el).data(null);
    return dat;
  },
  setValue: function(el, value) {
    /*$(el).text(value);*/
  },
  subscribe: function(el, callback) {
    $(el).on("click.indicator-overview-ns", ".indicator-item", function(e) {
      $(el).data(
        {
          indicatorset: $(e.target).attr('indicatorset') + "--" + Math.random(),
          indicator: $(e.target).attr('indicator') + "--" + Math.random(),
          measure: $(e.target).attr('measure') + "--" + Math.random(),
          tumour: $(e.target).attr('tumour') + "--" + Math.random(),
          admission: $(e.target).attr('admission') + "--" + Math.random()
        });
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".indicator-overview-ns");
  }
});

Shiny.inputBindings.register(indicatorOverviewBinding);