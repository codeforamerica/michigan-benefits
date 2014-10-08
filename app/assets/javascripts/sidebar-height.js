function setContainerHeight() {
  var tabbarHeight = 45; // from $tabbar-height in foundation_and_overrides.scss
  var height = $(document).height() - tabbarHeight;
  $('.app-nav').height(height); 
  $('.app-aside').height(height);        
}

$(document).on("ready page:load", setContainerHeight);
$(window).resize(setContainerHeight);
