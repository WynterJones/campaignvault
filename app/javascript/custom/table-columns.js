'use strict'

const tableColumns = {

  init: (sortable, tagifyApp) => {
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
      let taggedKeys = key;
      let regex = /\[\[.*?\]\]/g;
      const matches = taggedKeys.matchAll(regex);
      for (let match of matches) {
        taggedKeys = taggedKeys.replace(match, `[[${match[0].replace('[[{"value":"', '').replace('"}]]', '').replace("value", '')}]]`)
      }
      $('#table-column-list').append(tableColumns.buildColumnTag(title, taggedKeys))
      $('#table-column-name, #table-column-key').val('')
      tableColumns.saveColumnPositions()
      $('#table-column-list .table-column-badge').last().find('#hidden-keys').val(JSON.stringify(taggedKeys))
      $('#table-new-column').hide()
      $('.tagify__input').html('')
    }
  },

  update: (e, element, sortable) => {
    e.preventDefault()
    $('.no-table-columns').remove()
    const title = $('#table-update-column #table-column-name').val()
    const key = $('#table-update-column #table-column-key').val()
    let taggedKeys = key;
    let regex = /\[\[.*?\]\]/g;
    const matches = taggedKeys.matchAll(regex);
    for (let match of matches) {
      taggedKeys = taggedKeys.replace(match, `[[${match[0].replace('[[{"value":"', '').replace('"}]]', '').replace("value", '')}]]`)
    }
    const index = $(element).attr('data-index')
    if (title !== '' && key !== '') {
      tableColumns.updateColumnPositions(title, taggedKeys, index, sortable)
      $('#table-update-column').remove()
    }
  },

  delete: (e, element) => {
    e.stopPropagation()
    $(element).parent().remove()
    tableColumns.saveColumnPositions()
  },

  close: () => {
    $('#table-update-column').remove()
  },

  showAddColumn: () => {
    $('#table-new-column').show()
    $('#update-table-column').hide()
    $('#add-table-column').show()
    $('#table-new-column input').val('').first().focus()
  },

  saveTableColumns: () => {
    $('#table_column_save_form').submit()
  },

  editTableColumn: (element, tagifyApp) => {
    if ($('#table-update-column').length > 0) {
      $('#table-update-column').remove()
    }
    const index = $(element).index()
    const cloned = $('#table-new-column').clone()
    const updateHTML = `<div id="table-update-column" class="card-block clearfix mb-3">
      <label>Edit Table Column</label>
      <input id="table-column-name" type="text" class="form-control mb-2" placeholder="Title">
      <textarea id="table-column-key" type="text" class="tagifier mb-2" placeholder="Key">${$(element).find('#hidden-key').val()}</textarea>
      <a href="#" class="btn btn-sm btn-outline-light" id="close-table-column">Cancel</a>
      <div class="float-right">
        <a href="#" class="btn btn-sm btn-warning" id="update-table-column">Update</a>
      </div>
    </div>`
    $(element).after(updateHTML)
    $(document).find('#table-update-column #table-column-name').val(JSON.parse($(element).find('#hidden-title').val()))
    $('#update-table-column').attr('data-index', index)
    const whitelist_columns = []
    $('.popup-table-key').each(function() {
      whitelist_columns.push($(this).text())
    })
    const tagifyInput = $('#table-update-column #table-column-key')[0]
    const editTagify = new tagifyApp(tagifyInput, {
      mixTagsInterpolator: ['[[', ']]'],
      mode: 'mix',
      pattern: /#/,
      whitelist: whitelist_columns,
      dropdown: {
        enabled: 1,
        maxItems: 5,
        highlightFirst: true,
        fuzzySearch: true
      }
    })
    editTagify.on('input', function(e) {
      let prefix = e.detail.prefix
      if(prefix) {
        if(prefix == '#') {
          editTagify.settings.whitelist = whitelist_columns
          editTagify.dropdown.show.call(editTagify, e.detail.value)
        }
      }
    })
    editTagify.parseMixTags($(element).attr('data-key'))
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
      all_structure.push(JSON.parse($(this).find('#hidden-title').val()))
      all_column_keys.push(JSON.parse($(this).find('#hidden-key').val()))
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
    return `<span class="table-column-badge badge badge-outline-secondary">
      <textarea id="hidden-key" class="hide">${JSON.stringify(key)}</textarea>
      <textarea id="hidden-title" class="hide">${JSON.stringify(title)}</textarea>
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
