// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// = require jquery
// = require jquery_ujs
// = require handlebars
// = require devise-otp
// = require_tree .

var textWell = (function () {
  return {
    init: function () {
      $(document).on('click', '.textwell .textwell__expander', function () {
        $(this).parent('.textwell').addClass('textwell--expanded')
      })
    }
  }
})()

var radioSelector = (function () {
  var rs = {
    init: function () {
      $('.radio-button').each(function (index, button) {
        if ($(this).find('input').is(':checked')) {
          $(this).addClass('is-selected')
        }

        $(this).find('input').click(function (e) {
          $(this).parent().siblings().removeClass('is-selected')
          $(this).parent().addClass('is-selected')
        })
      })
    }
  }
  return {
    init: rs.init
  }
})()

var checkboxSelector = (function () {
  var cs = {
    init: function () {
      $('.checkbox').each(function (index, button) {
        if ($(this).find('input').is(':checked')) {
          $(this).addClass('is-selected')
        }

        $(this).find('input').click(function (e) {
          if ($(this).is(':checked')) {
            $(this).parent().addClass('is-selected')
          }else {
            $(this).parent().removeClass('is-selected')
          }
        })
      })
    }
  }
  return {
    init: cs.init
  }
})()

var yesNoButtons = (function () {
  var yn = {
    init: function () {
      $('[data-no]').on('click', function () {
        $('input.boolean-answer').val('0')
      })

      $('[data-yes]').on('click', function () {
        $('input.boolean-answer').val('1')
      })
    }
  }
  return {
    init: yn.init
  }
})()

$(document).ready(function () {
  radioSelector.init()
  checkboxSelector.init()
  textWell.init()
  yesNoButtons.init()
})
