$(document).on('turbolinks:load', () => {
  $('#table-selectAll').click(function() {
    $('.dt-buttons .dt-button').eq(0).trigger('click')
  })

  $('#table-deselectAll').click(function() {
    $('.dt-buttons .dt-button').eq(1).trigger('click')
  })

  $('#table-deleteSelected').click(function() {
    $('.dt-buttons .dt-button').eq(2).trigger('click')
  })
})
