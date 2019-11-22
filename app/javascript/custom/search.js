'use strict'

const component = require("custom/components")

const search = {

  init: () => {
    if (window.location.search.includes('search')) {
      const value = window.location.pathname.split('/')
      $('#searchDB').find(`option[value='${value[2]}']`).attr('selected','selected')

      if (component.getUrlParameter('search') !== '') {
        $('.searching-for').show()
        $('.searching-for strong').text(component.getUrlParameter('search'))
      } else {
        $('.searching-for').hide()
      }
    }
  },

  search: (e, element) => {
    const type = $(element).attr('data-type')
    const value = $(element).val()
    const keycode = ((typeof e.keyCode !='undefined' && e.keyCode) ? e.keyCode : e.which)

    if (keycode === 13) {
      if (typeof type !='undefined' && type !== 'Select a Database' && type !== '' && type !== null && value !== '') {
        window.location = `${window.location.protocol}//${window.location.host}${window.location.pathname}?search=${value}`
      } else {
        alert('Select a database, it cannot be blank.')
      }
    }
  }

}

module.exports = search
