'use strict'

const totals = {

  changeType: (element) => {
    const type = $(element).val()
    $('#total-manager .card-block').hide()
    $(`#total-manager .card-block[data-type="${type}"]`).show()
  },

  changeValue: (element) => {
    let stats = $('#database_stats').val()
    if (stats == '{}') {
      stats = { "stats": [] }
    } else {
      stats = JSON.parse(stats)
    }
    const statCount = stats['stats'].length
    const type = $(element).attr('data-type')
    const name = $(element).attr('data-name')
    const value = $(element).val()
    let newTotal = ''
    console.log(statCount)
    if (type == 'sum') {
      newTotal = { "type": type, "column": value }
      if (statCount == 0) {
        stats['stats'].push(newTotal)
      } else {
        stats['stats'][(statCount - 1)] = newTotal
      }
    }
    else if (type == 'countMatch') {
      
    }
    else if (type == 'countContains') {

    }
    $('#database_stats').val(JSON.stringify(stats))
  }

}

module.exports = totals
