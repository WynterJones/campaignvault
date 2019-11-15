'use strict'

const appPopup = {

  show: (element) => {
    if ($(element).index() != 0) {
      let template = $(element).parent().attr('data-template')
      $('#row-data-popup').html($(`#${template}`).html())
      $('#popup-wrapper').fadeIn(200)
      $('#popup').attr('style', 'right: 0')
    }
  },

  hide: () => {
    $('#popup').attr('style', 'right: -500px')
    setTimeout(function() {
      $('#popup-wrapper').fadeOut(300)
    }, 100)
  },

  popupClick: (e) => {
    e.stopPropagation()
    e.preventDefault()
  }

}

module.exports = appPopup
