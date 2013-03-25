$(document).bind("mobileinit", function() {
  $.mobile.defaultPageTransition = 'slide';
});

$(document).bind("pageinit", function() {

});

$(document).bind('pageshow', function() {
  $($('.page.ui-page-active form :input:visible')[0]).focus();
});