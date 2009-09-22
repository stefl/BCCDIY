// Code by Magnificent - http://groups.google.com/group/jquery-en/browse_thread/thread/36696140668f3d10?pli=1
//START text resizer
//on dom ready either set default cookie or read existing cookie
$(function() {
  //if no cookie, set cookie for default textsize of 1 (out of 3 possible sizes)
  //persist cookie for 365 days, 1 year
  if (!$.cookie("textsize")){
          $.cookie("textsize", "1", { path: '/', expires: 365 });
  }

  //get cookie value and pass to textResize function
  var cookie_val = $.cookie("textsize");
  console.log("onload: " + cookie_val);
  textResize(cookie_val);

});

function textResize(level){
  level = parseInt(level); 
  var body = $("body");
  console.log("textResize: " + level);

  switch(level) {
    case 1:
      body.removeClass('bigText biggerText');
      $.cookie("textsize", "1", { path: '/', expires: 365 });
      break;
    case 2:
      body.removeClass('biggerText').addClass('bigText');
      $.cookie("textsize", "2", { path: '/', expires: 365 });
      break;
    case 3:
      body.addClass('biggerText');
      $.cookie("textsize", "3", { path: '/', expires: 365 });
      break;
  }
}

//END text resizer