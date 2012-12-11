//create singleton to namespace js
if (!branston) {
  var branston = {};
}

branston.forms = (function(){

	function isNumberKey(e){
		var key;
		var keychar;
		if (window.event) {
			key = window.event.keyCode;
		} else if (e) {
			key = e.which;
		} else {
			return true;
		}

		keychar = String.fromCharCode(key);
		if (key == 13) {
			this.jump();
		} else if ((key == null) || (key == 0) || (key == 8) || (key == 9) || (key == 27)) {
			return true;
		} else if ((("0123456789").indexOf(keychar) > -1)) {
			return true;
		} else {
			return false;
		}
	}

	return{
		numericOnly: function(e) {
			try {
				isNumberKey(e);
			} catch(e) {
				alert("numericOnly exception: " + e);
			}
		},

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
	if($(".thumbnail .caption").exists()){
		branston.stories.init();
	}
});
