/**
* jQuery function to check the max height of a group of objects
*
* @returns [Integer]
*   The max height of all objects
*
* @example
*   $(".panels .panel").maxHeight();
*
* Note: it might be required to reset the height first. If so do it like this:
*   $(".panels .panel").height("").maxHeight();
*/
(function($){
  $.fn.maxHeight = function() {
    var max = 0;
    this.each(function() {
      max = Math.max( max, $(this).height() );
    });
    return max;
  };
})(jQuery);

/**
* jQuery function to a param from URL params
*
* @returns [String]
*   Any params found
*
* @example
*   $.fn.urlParam("debug")
*/
(function($){
  $.fn.urlParam = function(name){
    var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (!results){ return 0; }
    return results[1] || 0;
  };
})(jQuery);

/**
* jQuery function to wrap an element's inner content with an another tag
*
* @param [String] tag
*   The tag to use
*
* @param [String] options
*   Options for the tag
*
* @example
*   $.fn.wrapContentsWith("a", {"href":"#"})
*/
(function($){
  $.fn.wrapContentsWith = function(tag, options){
    var contents = this.html();
    this.html($(tag, options).html(contents));
  };
})(jQuery);

/**
* jQuery function to make an input field only accept numeric values
*
* @example
*   $.fn.numericOnly()
*/
(function($){
  $.fn.numericOnly = function(){
    this.bind("keypress", function(e){
      if((e.which!=8) && (e.which!=0) && (e.which<48 || e.which>57)) {
        e.preventDefault();
      }
    });
  };
})(jQuery);