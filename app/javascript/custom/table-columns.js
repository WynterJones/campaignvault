'use strict'

const tableColumns = {

  init: (sortable) => {
    if ($('#table_column_save_form').length > 0) {
      const table_columns = JSON.parse($('#final-table-columns').val())
      const all_structure = table_columns['structure']
      const all_final_keys = table_columns['keys']
      $('#table-column-list').html('')
      all_structure.forEach(function(title, index) {
        if (title !== '') {
          $('#table-column-list').append(tableColumns.buildColumnTag(title, all_final_keys[index]))
        }
      })
      if ($('#final-structure').val() === '') {
        $('#table-column-list').html(tableColumns.buildNoData())
      }
      sortable.create(document.getElementById('table-column-list'), {
        handle: '.column-grip',
        onUpdate: function(evt) {
      		tableColumns.saveColumnPositions()
      	}
      })
    }
  },

  add: (e) => {
    e.preventDefault()
    $('.no-table-columns').remove()
    const title = $('#table-column-name').val()
    const key = $('#table-column-key').val()
    if (title !== '' && key !== '') {
      $('#table-column-list').append(tableColumns.buildColumnTag(title, key))
      $('#table-column-name, #table-column-key').val('')
      tableColumns.saveColumnPositions()
      $('#table-new-column').hide()
    } else {
      alert('Title and Key cannot be blank.')
    }
  },

  update: (e, element, sortable) => {
    e.preventDefault()
    $('.no-table-columns').remove()
    const title = $('#table-column-name').val()
    const key = $('#table-column-key').val()
    const index = $(element).attr('data-index')
    if (title !== '' && key !== '') {
      $('#table-column-name, #table-column-key').val('')
      tableColumns.updateColumnPositions(title, key, index, sortable)
      $('#table-new-column').hide()
    } else {
      alert('Title and Key cannot be blank.')
    }
  },

  delete: (e, element) => {
    e.stopPropagation()
    $(element).parent().remove()
    tableColumns.saveColumnPositions()
  },

  close: () => {
    $('#table-new-column').hide()
  },

  showAddColumn: () => {
    $('#table-new-column').show()
    $('#table-new-column label').text('New Table Column')
    $('#update-table-column').hide()
    $('#add-table-column').show()
    $('#table-new-column input').val('').first().focus()
  },

  saveTableColumns: () => {
    $('#table_column_save_form').submit()
  },

  editTableColumn: (element) => {
    $('#table-new-column').show()
    $('#table-new-column label').text('Edit Table Column')
    $('#table-column-name').val($(element).attr('data-title'))
    $('#table-column-key').val($(element).attr('data-key'))
    $('#update-table-column').show()
    const index = $(element).index()
    $('#update-table-column').attr('data-index', index)
    $('#add-table-column').hide()
  },

  enterOnKey: (e) => {
    const keycode = ((typeof e.keyCode !='undefined' && e.keyCode) ? e.keyCode : e.which)
    if (keycode === 13) {
      e.preventDefault()
      $('#add-table-column').trigger('click')
      $('#table-column-name').focus()
    }
  },

  addColumnFromData: (element) => {
    if (!$(element).hasClass('active')) {
      $(element).addClass('active')
      const key = $(element).find('.popup-table-key').text()
      const keyArray = key.split('.')
      const keyName = keyArray[keyArray.length-1].replace(/\_/g, ' ')
      $('#table-column-name').val(keyName)
      $('#table-column-key').val(key)
      $('#add-table-column').trigger('click')
    }
  },

  saveColumnPositions: () => {
    const all_structure = []
    const all_column_keys = []
    $('#table-column-list .table-column-badge').each(function(index) {
      all_structure.push($(this).attr('data-title'))
      all_column_keys.push($(this).attr('data-key'))
    })
    const table_columns = {
      "structure": all_structure,
      "keys": all_column_keys
    }
    $('#final-table-columns').val(JSON.stringify(table_columns))
    if ($('#final-table-columns').val() === '{}') {
      $('#table-column-list').html(tableColumns.buildNoData())
    }
  },

  updateColumnPositions: (title, key, index, sortable) => {
    const table_columns = JSON.parse($('#final-table-columns').val())
    const all_structure = table_columns['structure']
    const all_column_keys = table_columns['keys']
    all_structure[index] = title
    all_column_keys[index] = key
    const updated_table_columns = {
      "structure": all_structure,
      "keys": all_column_keys
    }
    $('#final-table-columns').val(JSON.stringify(table_columns))
    tableColumns.init(sortable)
  },

  buildColumnTag: (title, key) => {
    return `<span class="table-column-badge badge badge-outline-secondary" data-key="${key}" data-title="${title}">
      <div class="column-grip">
        <i class='fas fa-grip-lines'></i>
      </div>
      <i class="fas fa-times delete-column-badge"></i>
      <span class="edit-column-badge">${title}</span>
      <br />
      <small style="text-transform: lowercase">${key}</small>
    </span>`
  },

  buildNoData: () => {
    return `<div class="no-table-columns text-muted text-center p-2">Add columns to represent your data in the table.</div>`
  }

}

module.exports = tableColumns
