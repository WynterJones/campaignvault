'use strict'

const totalManager = {

  initEdit: () => {
    let stats = $('#database_stats').val()
    const index = $('#types_of_totals').attr('data-edit-index')
    stats = JSON.parse(stats)
    const current_stat = stats['stats'][index]
    const element = `#total-manager .card-block[data-type="${current_stat['type']}"]`
    $('#types_of_totals').val(current_stat['type']).hide()
    $('#total-manager .card-block').hide()
    $('#delete-current-total').show()
    $(element).show()
    $(element).find('select[data-name="column"]').val(current_stat['column'])
    $(element).find('input[data-name="title"]').val(current_stat['title'])
    $(element).find('input[data-name="prepend"]').val(current_stat['prepend'])
    $(element).find('input[data-name="append"]').val(current_stat['append'])
    $(element).find('input[data-name="string"][data-type="match"]').val(current_stat['match'])
    $(element).find('input[data-name="string"][data-type="contains"]').val(current_stat['contains'])
    $(element).find('select[data-name="show-as"][data-type="contains"]').val(current_stat['show-as'])
    $(element).find('select[data-name="show-as"][data-type="match"]').val(current_stat['show-as'])
  },

  changeType: (element) => {
    const type = $(element).val()
    if ($('#types_of_totals')[0].hasAttribute('data-edit-index')) {
      totalManager.initEdit()
    }
    else {
      $('#total-manager .card-block').hide()
      $(`#total-manager .card-block[data-type="${type}"]`).show()
    }
  },

  delete: (e, element) => {
    e.preventDefault()
    if (!$(element)[0].hasAttribute('disabled')) {
      let stats = $('#database_stats').val()
      stats = JSON.parse(stats)
      const index = $('#types_of_totals').attr('data-edit-index')
      stats['stats'].splice(index, 1)
      $('#database_stats').val(JSON.stringify(stats))
      $('.modal-content form').submit()
      $(element).attr('disabled', 'disabled')
    }
  },

  save: (e, element) => {
    e.preventDefault()
    if (!$(element)[0].hasAttribute('disabled')) {
      const type = $('#types_of_totals').val()
      let newStat = ''
      let stats = $('#database_stats').val()
      if (stats == '{}') {
        stats = { "stats": [] }
      }
      else {
        stats = JSON.parse(stats)
      }
      if (type == 'sum') {
        const column = $('[data-type="sum"][data-name="column"]').val()
        const title = $('[data-type="sum"][data-name="title"]').val()
        const prepend = $('[data-type="sum"][data-name="prepend"]').val()
        const append = $('[data-type="sum"][data-name="append"]').val()
        newStat = { "type": type, "column": column, "title": title, "prepend": prepend, "append": append }
      }
      else if (type == 'match') {
        const column = $('[data-type="match"][data-name="column"]').val()
        const title = $('[data-type="match"][data-name="title"]').val()
        const string = $('[data-type="match"][data-name="string"]').val()
        const prepend = $('[data-type="match"][data-name="prepend"]').val()
        const append = $('[data-type="match"][data-name="append"]').val()
        const show_as = $('[data-type="match"][data-name="show-as"]').val()
        newStat = { "type": type, "column": column, "match": string, "title": title, "prepend": prepend, "append": append, "show-as": show_as }
      }
      else if (type == 'contains') {
        const column = $('[data-type="contains"][data-name="column"]').val()
        const title = $('[data-type="contains"][data-name="title"]').val()
        const string = $('[data-type="contains"][data-name="string"]').val()
        const prepend = $('[data-type="contains"][data-name="prepend"]').val()
        const append = $('[data-type="contains"][data-name="append"]').val()
        const show_as = $('[data-type="match"][data-name="show-as"]').val()
        newStat = { "type": type, "column": column, "contains": string, "title": title, "prepend": prepend, "append": append, "show-as": show_as }
      }
      if (newStat != '' && !$('#types_of_totals')[0].hasAttribute('data-edit-index')) {
        stats['stats'].push(newStat)
      }
      else if (newStat != '' && $('#types_of_totals')[0].hasAttribute('data-edit-index')) {
        stats['stats'][$('#types_of_totals').attr('data-edit-index')] = newStat
      }
      $('#database_stats').val(JSON.stringify(stats))
      $('.modal-content form').submit()
      $(element).attr('disabled', 'disabled')
    }
  }

}

module.exports = totalManager
