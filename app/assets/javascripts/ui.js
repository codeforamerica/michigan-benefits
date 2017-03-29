var incrementer = (
  function() {
    var i = {
      increment: function(input) {
        var max = parseInt($(input).attr('max'));
        var value = parseInt($(input).val());
        if(max != undefined) {
          if(value < max) {
            $(input).val(value+1);
          }
        }
        else {
          $(input).val(parseInt($(input).val())+1);
        }
      },
      decrement: function(input) {
        var min = parseInt($(input).attr('min'));
        var value = parseInt($(input).val());
        if(min != undefined) {
          if(value > min) {
            $(input).val(value-1);
          }
        }
        else {
          $(input).val(value-1);
        }

      },
      init: function() {
        $('.incrementer').each(function(index, incrementer) {
          var addButton = $(incrementer).find('.incrementer__add');
          var subtractButton = $(incrementer).find('.incrementer__subtract');
          var input = $(incrementer).find('.text-input');

          $(addButton).click(function(e) {
            i.increment(input);
          });

          $(subtractButton).click(function(e) {
            i.decrement(input);
          });
        });
      }
    }
    return {
      init: i.init
    }
  }
)();

var radioSelector = (
  function() {
    var rs = {
      init: function() {
        $('.radio-button').each(function(index, button){
          if($(this).find('input').is(':checked')) {
            $(this).addClass('is-selected');
          }

          $(this).find('input').click(function(e) {
            $(this).parent().siblings().removeClass('is-selected');
            $(this).parent().addClass('is-selected');
          })
        })
      }
    }
    return {
      init: rs.init
    }
  }
)();

var checkboxSelector = (
  function() {
    var cs = {
      init: function() {
        $('.checkbox').each(function(index, button){
          if($(this).find('input').is(':checked')) {
            $(this).addClass('is-selected');
          }

          $(this).find('input').click(function(e) {
            if($(this).is(':checked')) {
              $(this).parent().addClass('is-selected');
            }
            else {
              $(this).parent().removeClass('is-selected');
            }
          })
        })
      }
    }
    return {
      init: cs.init
    }
  }
)();

$(function() {
  incrementer.init();
  radioSelector.init();
  checkboxSelector.init();
});