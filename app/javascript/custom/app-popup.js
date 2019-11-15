'use strict'

const appPopup = {

  show: (element) => {
    if ($(element).index() != 0) {
      let template = $(element).parent().attr('data-template')
      $('#row-data-popup').html($(`#${template}`).html())
      $('#popup-wrapper').fadeIn(200)
      $('#popup').attr('style', 'right: 0')
      $('body').attr('style', 'overflow: hidden')
      $('#popup-nav a').first().trigger('click')
    }
  },

  hide: () => {
    $('body').removeAttr('style')
    $('#popup').attr('style', 'right: -500px')
    setTimeout(function() {
      $('#popup-wrapper').fadeOut(300)
    }, 100)
  },

  popupClick: (e) => {
    e.stopPropagation()
    e.preventDefault()
  },

  tab: (element) => {
    const tab = $(element).attr('data-tab')
    $('#popup-nav a').removeClass('active')
    $(element).addClass('active')
    $('.tab').hide()
    $(`#${tab}`).fadeIn(100)
  }

}

module.exports = appPopup
