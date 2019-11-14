$(document).on('turbolinks:load', () => {

  if (window.location.pathname.includes('database/')) {
    const value = window.location.pathname.split('/')
    $('#searchDB').find(`option[value='${value[2]}']`).attr('selected','selected')

    if (getUrlParameter('search') !== '') {
      $('.searching-for').show()
      $('.searching-for strong').text(getUrlParameter('search'))
    } else {
      $('.searching-for').hide()
    }
  }

  $(document).on('keydown', '#search', function(e) {
    const type = $(this).attr('data-type')
    const value = $(this).val()
    const keycode = ((typeof e.keyCode !='undefined' && e.keyCode) ? e.keyCode : e.which)

    if (keycode === 13) {
      if (typeof type !='undefined' && type !== 'Select a Database' && type !== '' && type !== null && value !== '') {
        window.location = `${window.location.protocol}//${window.location.host}/database/${type}?search=${value}`
      } else {
        alert('Select a database, it cannot be blank.')
      }
    }
  })

})

function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
    const regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
    const results = regex.exec(location.search)
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '))
}
