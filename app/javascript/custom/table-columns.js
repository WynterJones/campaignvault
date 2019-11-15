'use strict'

const tableColumns = {

  init: (sortable) => {
    if ($('#final-structure').length > 0) {
      const all_structure = $('#final-structure').val().split(',')
      const all_final_keys = $('#final-column-keys').val().split(',')

      $('#table-column-list').html('')

      all_structure.forEach(function(title, index) {
        if (title !== '') {
          $('#table-column-list').append(`<span class="table-column-badge badge badge-outline-secondary tippyColumn" data-tippy-content="<strong>key:</strong> ${all_final_keys[index]}" data-key="${all_final_keys[index]}"><div class="column-grip" style='cursor: move;float: left;padding: 7px 5px;margin-right: 10px;font-size: 1.1em'><i class='fas fa-grip-lines'></i></div><i class="fas fa-times delete-column-badge"></i> <span class="edit-column-badge">${title}</span><br /><small style="text-transform: lowercase">${all_final_keys[index]}</small></span>`)
        }
      })

      if ($('#final-structure').val() === '') {
        $('#table-column-list').html('<span class="no-table-columns text-muted p-2" style="text-align: center;display:block">Add columns to represent your data in the table.</span>')
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
      $('#table-column-list').append(`<span class="table-column-badge badge badge-outline-secondary tippyColumn" data-tippy-content="<strong>key:</strong> ${key}" data-key="${key}"><i class="fas fa-times delete-column-badge"></i> <span class="edit-column-badge">${title}</span><br /><small style="text-transform: lowercase">${key}</small></span>`)
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
    $('#table-column-name').val($(element).find('span').text())
    $('#table-column-key').val($(element).find('small').text())
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

  saveColumnPositions: () => {
    let all_structure = ''
    let all_column_keys = ''
    $('#table-column-list .table-column-badge').each(function(index) {
      const key = $(this).attr('data-key')
      const title = $(this).find('span').text().trim()
      if (index === 0) {
        all_structure += `${title}`
        all_column_keys += `${key}`
      } else {
        all_structure += `,${title}`
        all_column_keys += `,${key}`
      }
    })
    $('#final-structure').val(all_structure)
    $('#final-column-keys').val(all_column_keys)

    if ($('#final-structure').val() === '') {
      $('#table-column-list').html('<span class="no-table-columns text-muted p-2" style="text-align: center;display:block">Add columns to represent your data in the table.</span>')
    }
  },

  updateColumnPositions: (title, key, index, sortable) => {
    let all_structure = $('#final-structure').val().split(',')
    let all_column_keys = $('#final-column-keys').val().split(',')
    all_structure[index] = title
    all_column_keys[index] = key
    $('#final-structure').val(all_structure)
    $('#final-column-keys').val(all_column_keys)
    tableColumns.init(sortable)
    console.log(all_structure, all_column_keys)
    console.log(title, key, index)
  }

}

module.exports = tableColumns
