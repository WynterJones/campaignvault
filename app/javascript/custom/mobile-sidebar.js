$(document).on('turbolinks:load', () => {
  $('#showSidebar').click(function(e) {
    e.preventDefault()
    $('.sidebar').toggle()
  })
})
