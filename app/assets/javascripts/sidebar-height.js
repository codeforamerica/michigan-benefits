function setContainerHeight() {
  var tabbarHeight = 45; // from $tabbar-height in foundation_and_overrides.scss
  var height;

  if ($('.toggle-topbar:visible').length > 0) {
    // small screen
    $('.app-nav').height("auto");
    $('.app-aside').height("auto");
  } else {
    height = $(document).height() - tabbarHeight;
    $('.app-nav').height(height);
    $('.app-aside').height(height);
  }
}

$(document).ready(setContainerHeight);
$(window).resize(setContainerHeight);
