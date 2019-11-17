'use strict'

const components = {

  getUrlParameter: (name) => {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
    const regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
    const results = regex.exec(location.search)
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '))
  },

  counter: (id, CountUp) => {
    const countUp = new CountUp(`${id}`, $(`#${id}`).data('total'));
    countUp.start()
  }

}

module.exports = components
