$(document).on('turbolinks:load', () => {
  $('.click-to-copy').click(function() {
    $(this).focus().select()
    document.execCommand("copy")
  })

  $('.datatables tr td').click(function() {
    if ($(this).index() != 0) {
      $('#popup-wrapper').show()
      let template = $(this).parent().attr('data-template')
      $('#row-data-popup').html($(`#${template}`).html())
    }
  })

  $('#popup-wrapper').click(function() {
    $('#popup-wrapper').hide()
  })

  $('#popup').click(function(e) {
    e.stopPropagation()
    e.preventDefault()
  })
})
