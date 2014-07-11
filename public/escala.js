$(function() {

  // Facebook
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

  // Twitter
  !function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");

  // Google+
  window.___gcfg = {lang: 'es'};
  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();

  // Track Event App Store
  $('#apple_app_store_link').click(function() {
    _gaq.push(['_trackEvent', 'links', 'click', 'apple_app_store']);
  });

  // Track Event Google Play Store
  $('#google_play_store_link').click(function() {
    _gaq.push(['_trackEvent', 'links', 'click', 'google_play_store']);
  });

  // Track Event planilla excel
  $('#planilla_button').click(function() {
    _gaq.push(['_trackEvent', 'links', 'click', 'planilla_excel']);
  });

  $('#orden').buttonset();

});