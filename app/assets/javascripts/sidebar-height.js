function setContainerHeight() {
  if ($('.toggle-topbar:visible').length > 0) {
    return;
  }
  var tabbarHeight = 45; // from $tabbar-height in foundation_and_overrides.scss
  var height = $(document).height() - tabbarHeight;
  $('.app-nav').height(height);
  $('.app-aside').height(height);
}

$(document).ready(setContainerHeight);
$(window).resize(setContainerHeight);
