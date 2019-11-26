'use strict'

const user = {

  change: (element) => {
    const value = $(element).val()
    if (value == '3') {
      $('#optional_limits').show()
    }
    else {
      $('#optional_limits').hide()
    }
  }

}

module.exports = user
