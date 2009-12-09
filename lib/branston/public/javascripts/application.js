// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var Util = {
  Form : {
    selectChange : function (event) {
      var el = event.element();
      if (el.options[el.options.selectedIndex].value != "") el.form.submit();
      return false;
    }
  }
}
