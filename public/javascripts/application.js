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
		}
	}
});

branston.stories = (function(){

	return{
		init: function(){
			$(".thumbnail .caption").each(function(){
				$caption = $(this);
		    $caption.find("h3").bind("click", function(e){
		    	e.preventDefault();
		      $caption.find(".details").toggleClass("hidden");
		  	});
		  });
		}
	}
});

$(function() {
	if($(".thumbnail .caption").exists()){
		branston.stories.init();
	}
});
