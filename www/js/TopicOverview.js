var topicOverviewBinding = new Shiny.InputBinding();
$.extend(topicOverviewBinding, {
  find: function(scope) {
    return $(scope).find(".regional-overview-binding");
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
    $(el).on("click.indicator-item", function(e) {
      var target = $(e.currentTarget);
      var d = {
        indicatorset: $(e.target).attr('indicatorset'),
        indicator: $(e.target).attr('indicator')
      };
      $(el).data(d);
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".regional-overview-binding");
  }
});

Shiny.inputBindings.register(topicOverviewBinding);