// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var Branston = {
    Form: {
        selectChange: function(event) {
            var el = event.element();
            if (el.options[el.options.selectedIndex].value != "") el.form.submit();
            return false;
        },

		numericOnly: function(e) {
	        try {
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
	        } catch(e) {
	            alert("numericOnly exception: " + e);
	        }
	    }
    },

   	Utils: {
		fadeFlash: function(flash){
			window.setTimeout(function() {
				Effect.SlideUp(flash); 
			}, 5000);
		}
	}
}
