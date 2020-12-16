var customLinkBinding = new Shiny.InputBinding();
$.extend(customLinkBinding, {
  find: function(scope) {
    return $(scope).find(".custom-link-binding");
  },
  getValue: function(el) {
    if(!$(el).data().indicator){
      return null;
    }
    toRet = $(el).data();
    $(el).data(null);
    return toRet;
  },
  setValue: function(el, value) {
    /*$(el).text(value);*/
  },
  subscribe: function(el, callback) {
    $(el).on("click.custom-link-ns", ".custom-link", function(e) {
      $(el).data(
        {
          "set":$(e.target).attr('set'),
          "indicator": $(e.target).attr('indicator'),
          "indid": $(e.target).attr('indid')
        });
       
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".custom-link-ns");
  }
});

Shiny.inputBindings.register(customLinkBinding);