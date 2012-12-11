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
* jQuery function to check if something exists.
*
* @returns [Boolean]
*   If the jQuery element(s) exists
*
* @example
*   $("#some-id").exists();
*/
(function($){
  $.fn.exists = function() {
    return this.length > 0;
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