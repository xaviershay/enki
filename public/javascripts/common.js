// Based on http://www.germanforblack.com/javascript-sleeping-keypress-delays-and-bashing-bad-articles
Function.prototype.only_every = function (millisecond_delay) {
  if (!window.only_every_func)
  {
    var function_object = this;
    window.only_every_func = setTimeout(function() { function_object(); window.only_every_func = null}, millisecond_delay);
   }
};

// http://www.ivanuzunov.net/top-10-javascript-stringprototype-extensions/
String.prototype.endsWith = function(t, i) {
  if (i==false) {
    return (t == this.substring(this.length - t.length));
  } else {
    return (t.toLowerCase() == this.substring(this.length - t.length).toLowerCase());
  }
}

// http://ozmm.org/posts/jquery_and_respond_to.html
jQuery.ajaxSetup({
  beforeSend: function(xhr) { xhr.setRequestHeader("Accept", "text/javascript"); }
});

// jQuery extensions
jQuery.prototype.any = function(callback) {
  return (this.filter(callback).length > 0)
}