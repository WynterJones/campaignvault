$(document).on('turbolinks:load', () => {
  const alert = $('#alert').html()
  const notice = $('#notice').html()

  if (alert !== '') {
    $('#alert').show()
    setTimeout(function() {
      $('#alert').fadeOut()
    }, 3000)
  }

  if (notice !== '') {
    $('#notice').show()
    setTimeout(function() {
      $('#notice').fadeOut()
    }, 3000)
  }
})
