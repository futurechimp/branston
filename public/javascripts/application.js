//create singleton to namespace js
if (!branston) {
  var branston = {};
}

branston.forms = (function(){

  return{
    selectChange: function(element) {
      if (element.options[element.options.selectedIndex].value != ""){
        element.form.submit();
      }
      return false;
    },

    // $(this).parent().next(\"#{append_to}\").append('#{escape_javascript(html)}');" #.replace(/NEW_RECORD/g, new Date().getTime()));"
    addNewObject:function(e, html){
      e.preventDefault();
      var element = $(e.target);
      if(e.target.tagName != "A"){
        element = element.parent("a");
      }
      element.parent().next().append(html); //.replace(/NEW_RECORD/g, new Date().getTime()));"
    },

    removeNewObject: function(element){
      // TODO:
    },

    removeExistingObject: function(element){
      // TODO:
    }
  }
})();

branston.stories = (function(){

  return{
    init: function(){
      $(".thumbnail .caption").each(function(){
        var $caption = $(this);
        var $heading = $caption.find("h3");
        $heading.wrapContentsWith("<a>", {"href":"#"});
        $heading.find("a").bind("click", function(e){
          e.preventDefault();
          $caption.find(".details").toggleClass("hidden");
        });

        var $statusSelect = $caption.find("select.status");
        $statusSelect.bind("change", function(e){
          branston.forms.selectChange(this);
        });
      });
    }
  }
})();

$(function() {
  branston.stories.init();
  $('.calendar').datepicker();
  $(".numeric").numericOnly();
});
