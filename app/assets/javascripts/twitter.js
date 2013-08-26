function tweetf() {

  $.ajax({
    type: "POST",
    url: "http://api.twitter.com/1.1/direct_messages/new.json",
    data: { text:'hello'},
    success: function(msg){
      alert(msg);
    },
    dataType: "jsonp"                        
  });

}
