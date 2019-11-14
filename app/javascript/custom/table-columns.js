import Sortable from 'sortablejs';

$(document).on('turbolinks:load', () => {
  if ($('#final-structure').length > 0) {

    $(document).on('click', '#add-table-column', function(e) {
      e.preventDefault()
      $('.no-table-columns').remove()
      const title = $('#table-column-name').val()
      const key = $('#table-column-key').val()
      if (title !== '' && key !== '') {
        $('#table-column-list').append(`<span class="table-column-badge badge badge-outline-secondary tippyColumn" data-tippy-content="<strong>key:</strong> ${key}" data-key="${key}">${title} <i class="fas fa-times delete-column-badge"></i></span>`)
        $('#table-column-name, #table-column-key').val('')
        saveColumnPositions()
      } else {
        alert('Title and Key cannot be blank.')
      }
    })

    $(document).on('click', '.delete-column-badge', function(e) {
      $(this).parent().remove()
      saveColumnPositions()
    })

    $(document).on('keydown', '#table-column-key', function(e) {
      const keycode = ((typeof e.keyCode !='undefined' && e.keyCode) ? e.keyCode : e.which)
      if (keycode === 13) {
        e.preventDefault()
        $('#add-table-column').trigger('click')
        $('#table-column-name').focus()
      }
    })

    const all_structure = $('#final-structure').val().split(',')
    const all_final_keys = $('#final-column-keys').val().split(',')

    all_structure.forEach(function(title, index) {
      if (title !== '') {
        $('#table-column-list').append(`<span class="table-column-badge badge badge-outline-secondary tippyColumn" data-tippy-content="<strong>key:</strong> ${all_final_keys[index]}" data-key="${all_final_keys[index]}">${title} <i class="fas fa-times delete-column-badge"></i></span>`)
      }
    })

    if ($('#final-structure').val() === '') {
      $('#table-column-list').html('<span class="no-table-columns text-muted p-2" style="text-align: center;display:block">Add columns to represent your data in the table.</span>')
    }

    Sortable.create(document.getElementById('table-column-list'), {
      onUpdate: function(evt) {
    		saveColumnPositions()
    	}
    })

    function saveColumnPositions() {
      let all_structure = ''
      let all_column_keys = ''
      $('#table-column-list .table-column-badge').each(function(index) {
        const key = $(this).attr('data-key')
        const title = $(this).text().trim()
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
    }

  }
})
