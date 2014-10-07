// TODO make this modular... for now it's all we need. 

function setContainerHeight() {
  var height = $(window).height();
  $('.app-nav').height(height); 
  $('.app-aside').height(height);        
}

$(window).resize(function(e) {
  console.log('window resized');
  setContainerHeight();
});

$(document).on("page:load", setContainerHeight);


// $(document).ready(setContainerHeight);
$(window).resize(setContainerHeight);
