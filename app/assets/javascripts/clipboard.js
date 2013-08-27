$(function () {
  var clip = new ZeroClipboard($(".js-copyclip"));
  
  clip.on( 'complete', function(client, args) {
        $('.js-copyclip-alert').show(500).removeClass('hide');
  } );

});