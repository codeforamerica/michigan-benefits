// TODO make this modular... for now it's all we need. 

function setContainerHeight() {
  var height = $(window).height();
  $('.app-nav').height(height); 
  $('.app-aside').height(height);        
}

$(document).on("page:load", setContainerHeight);
$(window).resize(setContainerHeight);
