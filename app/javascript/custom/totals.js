'use strict'

const totals = {

  changeType: (element) => {
    const type = $(element).val()
    $('#total-manager .card-block').hide()
    $(`#total-manager .card-block[data-type="${type}"]`).show()
  },

  saveValue: (e, element) => {
    e.preventDefault()
    if (!$(element)[0].hasAttribute('disabled')) {
      const type = $('#types_of_totals').val()
      let newStat = ''
      let stats = $('#database_stats').val()
      if (stats == '{}') {
        stats = { "stats": [] }
      } else {
        stats = JSON.parse(stats)
      }
      if (type == 'sum') {
        const column = $('[data-type="sum"][data-name="column"]').val()
        const title = $('[data-type="sum"][data-name="title"]').val()
        newStat = { "type": type, "column": column, "title": title }
      }
      else if (type == 'match') {
        const column = $('[data-type="match"][data-name="column"]').val()
        const title = $('[data-type="match"][data-name="title"]').val()
        const string = $('[data-type="match"][data-name="string"]').val()
        newStat = { "type": type, "column": column, "match": string, "title": title }
      }
      else if (type == 'contains') {
        const column = $('[data-type="contains"][data-name="column"]').val()
        const title = $('[data-type="contains"][data-name="title"]').val()
        const string = $('[data-type="contains"][data-name="string"]').val()
        newStat = { "type": type, "column": column, "contains": string, "title": title }
      }
      if (newStat != '') {
        stats['stats'].push(newStat)
      }
      $('#database_stats').val(JSON.stringify(stats))
      $('.modal-content form').submit()
      $(element).attr('disabled', 'disabled')
    }
  }

}

module.exports = totals
