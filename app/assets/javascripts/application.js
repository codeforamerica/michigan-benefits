// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// = require jquery
// = require jquery_ujs
// = require foundation
// = require turbolinks
// = require jquery.turbolinks
// = require_tree .

$(document).ready(function(){

  // Prevent a stupid bug in foundation
  // (https://github.com/zurb/foundation/pull/5988) that prevents equalizer
  // from working with turbolinks.
  //
  // This patch causes another bug, which is that equalizer.reflow is not
  // triggered when the browser window is resized.  Theoretically, this is OK
  // because resize is an uncommon occurrence.  The more common occurence is
  // that turbolinks change the content of the page.  In this case equalizer
  // re-runs, which is the necessary behavior.
  //
  // If you upgrade foundation, check whether this patch is still necessary:
  // remove the following line, reload a page, follow a turbo-link, and observe
  // whether Foundation throws an error: Uncaught TypeError: Cannot read
  // property 'before_height_change' of undefined
  $('[data-equalizer]').data('equalizer-init', Foundation.libs.equalizer.settings);

  $(document).foundation();
});
