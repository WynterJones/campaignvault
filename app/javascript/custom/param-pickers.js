'use strict'

const component = require("custom/components")

const paramPicker = {

  init: () => {
    if (component.getUrlParameter('timeframe') !== '') {
      $('#activity-date-picker').children(`option[value='?timeframe=${component.getUrlParameter('timeframe')}']`).prop('selected','selected')
    }
    if (component.getUrlParameter('per_page') !== '') {
      $('#table-show-amount').children(`option[value='?per_page=${component.getUrlParameter('per_page')}']`).prop('selected','selected')
    }
  },

  dateChange: (element) => {
    const value = parseURL($(element).val(), 'timeframe')
    const redirect_to = `${window.location.protocol}//${window.location.host}${window.location.pathname}${value}`
    window.location = redirect_to
  },

  perPageChange: (element) => {
    const value = parseURL($(element).val(), 'per_page')
    const redirect_to = `${window.location.protocol}//${window.location.host}${window.location.pathname}${value}`
    window.location = redirect_to
  },

  parseURL: (value, extra) => {
    if (component.getUrlParameter('page') !== '') {
      value += `&page=${component.getUrlParameter('page')}`
    }
    if (component.getUrlParameter('search') !== '') {
      value += `&search=${component.getUrlParameter('search')}`
    }
    if (component.getUrlParameter(extra) !== '') {
      value += `&${extra}=${component.getUrlParameter(extra)}`
    }
    return value
  }

}

module.exports = paramPicker
