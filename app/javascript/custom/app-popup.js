'use strict'

const appPopup = {

  show: (element) => {
    if ($(element).index() != 0) {
      $('#popup-wrapper').show()
      let template = $(element).parent().attr('data-template')
      $('#row-data-popup').html($(`#${template}`).html())
    }
  },

  hide: () => {
    $('#popup-wrapper').hide()
  },

  popupClick: (e) => {
    e.stopPropagation()
    e.preventDefault()
  }

}

module.exports = appPopup
