'use strict'

const clipboard = {

  copy: (element) => {
    $(element).focus().select()
    document.execCommand("copy")
  }

}

module.exports = clipboard
