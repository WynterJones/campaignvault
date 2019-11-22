'use strict'

const tableColumns = {

  init: (sortable, tagifyApp) => {
    if ($('#table_column_save_form').length > 0 && $('#final-table-columns').val() !== '' && $('#final-table-columns').val() !== '{}' && $('#final-table-columns').val() !== '{"structure":[],"keys":[]}') {
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
        onMove: function () {
          tableColumns.close()
        },
        onUpdate: function(evt) {
      		tableColumns.saveColumnPositions()
      	}
      })
    } else {
      $('#table-column-list').html('<div class="card-block" id="table_columns_explainer"><h5>Setup Table Columns</h5><p class="text-muted text-small mb-0">You can add custom table columns to show the data you want. Click new and add tags by using "#" to search. You can also click on a piece of data in the Row Data panel.</p></div>')
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
      $('#table-column-list').append(tableColumns.buildColumnTag(title, taggedKeys.replace('[[[[', '[[').replace(']]]]', ']]')))
      $('#table-column-name, #table-column-key').val('')
      tableColumns.saveColumnPositions()
      $('#table-column-list .table-column-badge').last().find('#hidden-keys').val(JSON.stringify(taggedKeys))
      $('#table-new-column').hide()
      $('.tagify__input').html('')
      $('#table_columns_explainer').remove()
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
      taggedKeys.replace('[[[[', '[[').replace(']]]]', ']]')
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
    $('#table-update-column').remove()
  },

  close: () => {
    $('#table-new-column, #table-update-column').remove()
    $('.table-column-badge').removeAttr('style')
  },

  showAddColumn: (tagifyApp) => {
    tableColumns.close()
    if ($('#table-update-column').length > 0) {
      $('#table-update-column').remove()
    }
    if ($('#table-new-column').length > 0) {
      $('#table-new-column').remove()
    }
    const added_keys = $('body').attr('data-table-column-key')
    const addHTML = `<div id="table-new-column" class="card-block clearfix mb-3">
      <span class="text-large mb-2 d-block font-weight-bold">New Column</span>
      <input id="table-column-name" type="text" class="form-control mb-2" placeholder="Title">
      <textarea id="table-column-key" type="text" class="tagifier mb-3" placeholder="Key"></textarea>
      <a href="#" class="btn btn-sm btn-secondary" id="close-table-column">Cancel</a>
      <div class="float-right">
        <a href="#" class="btn btn-sm btn-warning" id="add-table-column">Add</a>
      </div>
    </div>`
    $('#addTableHTML').html(addHTML)
    $('#addTableHTML').find('#table-column-key').val(added_keys)
    let whitelist_columns = []
    $('.popup-table-key').each(function() {
      if ($(this).text() != '') {
        whitelist_columns.push($(this).text())
      }
    })
    whitelist_columns = [...new Set(whitelist_columns)]
    const tagifyInput = $('.tagifier')[0]
    const tagify = new tagifyApp(tagifyInput, {
      mixTagsInterpolator: ['[[', ']]'],
      mode: 'mix',
      pattern: /#/,
      whitelist: whitelist_columns,
      dropdown: {
        enabled: 1,
        maxItems: 15,
        highlightFirst: true,
        fuzzySearch: true
      }
    })
    tagify.on('input', function(e) {
      let prefix = e.detail.prefix
      if(prefix) {
        if(prefix == '#') {
          tagify.settings.whitelist = whitelist_columns
          tagify.dropdown.show.call(tagify, e.detail.value)
        }
      }
    })
    $('#table-new-column input').val('').first().focus()
    tagify.parseMixTags($(document).find('#table-column-key').val())
    setTimeout(function() {
      $('body').removeAttr('data-table-column-key')
    }, 500)
  },

  saveTableColumns: () => {
    $('#table_column_save_form').submit()
  },

  editTableColumn: (element, tagifyApp) => {
    $('.table-column-badge').removeAttr('style')
    $(element).attr('style', 'background: #f2f3f8;border-bottom-left-radius: 0;border-bottom-right-radius: 0;')
    if ($('#table-update-column').length > 0) {
      $('#table-update-column').remove()
    }
    if ($('#table-new-column').length > 0) {
      $('#table-new-column').remove()
    }
    const index = $(element).index()
    const cloned = $('#table-new-column').clone()
    const updateHTML = `<div id="table-update-column" class="card-block clearfix mb-3"  style="margin-top: -11px;border-top-left-radius:0;border-top-right-radius:0;z-index: 2">
      <input id="table-column-name" type="text" class="form-control mb-2" placeholder="Title">
      <textarea id="table-column-key" type="text" class="tagifier mb-3" placeholder="Key">${$(element).find('#hidden-key').val()}</textarea>
      <a href="#" class="btn btn-sm btn-secondary" id="close-table-column">Cancel</a>
      <div class="float-right">
        <a href="#" class="btn btn-sm btn-warning" id="update-table-column">Update</a>
      </div>
    </div>`
    $(element).after(updateHTML)
    $(document).find('#table-update-column #table-column-name').val(JSON.parse($(element).find('#hidden-title').val()))
    $('#update-table-column').attr('data-index', index)
    let whitelist_columns = []
    $('.popup-table-key').each(function() {
      if ($(this).text() != '') {
        whitelist_columns.push($(this).text())
      }
    })
    whitelist_columns = [...new Set(whitelist_columns)]
    const tagifyInput = $('#table-update-column #table-column-key')[0]
    const editTagify = new tagifyApp(tagifyInput, {
      mixTagsInterpolator: ['[[', ']]'],
      mode: 'mix',
      pattern: /#/,
      whitelist: whitelist_columns,
      dropdown: {
        enabled: 1,
        maxItems: 15,
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
    editTagify.parseMixTags($('#table-column-key').val())
  },

  enterOnKey: (e) => {
    const keycode = ((typeof e.keyCode !='undefined' && e.keyCode) ? e.keyCode : e.which)
    if (keycode === 13) {
      e.preventDefault()
      $('#add-table-column').trigger('click')
      $('#table-column-name').focus()
    }
  },

  addColumnFromData: (e, element) => {
    const key = $(element).find('.popup-table-key').text()
    const keyArray = key.split('.')
    const keyName = keyArray[keyArray.length-1].replace(/\_/g, ' ')
    $('body').attr('data-table-column-key', `[[${key}]]`)
    $('#popup-nav a[data-tab="popup-manage-table"]').trigger('click')
    console.log(key, keyArray, keyName)
    $('#showAddColumn').trigger('click')
    $('#table-column-name').val(keyName.replace(/\b\w/g, l => l.toUpperCase()))
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
    </span>`
  },

  buildNoData: () => {
    return `<div class="no-table-columns text-muted text-center p-2">Add columns to represent your data in the table.</div>`
  }

}

module.exports = tableColumns
