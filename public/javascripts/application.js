//create singleton to namespace js
if (!branston) {
  var branston = {};
}

branston.forms = (function(){

  function setCorrectTarget(e){
    var $element = $(e.target);
    if(e.target.tagName != "A"){
      $element = $element.parent("a");
    }
    return $element;
  }

  function checkScenarios(){
    $("div.scenario").each(function(){
      var $scenario = $(this);
      if($scenario.html().trim() == "" || $scenario.find("> fieldset").is(":hidden")){
        $scenario.remove();
      }
    });
  }

  return{
    selectChange: function(element) {
      if (element.options[element.options.selectedIndex].value != ""){
        element.form.submit();
      }
      return false;
    },

    // $(this).parent().next(\"#{append_to}\").append('#{escape_javascript(html)}');" #.replace(/NEW_RECORD/g, new Date().getTime()));"
    addFormObject:function(e, html){
      e.preventDefault();
      var $element = setCorrectTarget(e);
      $element.parent().next().append(html); //.replace(/NEW_RECORD/g, new Date().getTime()));"
    },

    deleteFormObject: function(e, isNew){
      e.preventDefault();
      var $element = setCorrectTarget(e);
      var $fieldset = $element.parent().parent().parent('fieldset')

      if(isNew){
        $fieldset.remove();
      }else{
        $fieldset.hide();
        $element.prev().val('1');
      }

      checkScenarios();
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
