'use strict'

const chart = {

  change: (element) => {
    const type = $(element).val()
    window.location = `${window.location.protocol}//${window.location.host}${window.location.pathname}?chart=${type}`
  }

}

module.exports = chart
