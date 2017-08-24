/* global $ */

$(document).ready(function () {
  $('[data-money]').maskMoney({
    precision: 0,
    prefix: '$'
  })
})
