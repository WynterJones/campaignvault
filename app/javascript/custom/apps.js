$(document).on('turbolinks:load', () => {
  $('.card-select-app').click(function() {
    let type = ''
    $(this).toggleClass('card-app-selected')
    $('.card-app-selected').each(function() {
      type += `,${$(this).attr('data-type')}`
    })
    $('#apps-input').val(type.replace(',', ''))
  })
})
