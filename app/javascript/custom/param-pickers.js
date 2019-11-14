$(document).on('turbolinks:load', () => {
  if (getUrlParameter('timeframe') !== '') {
    $('#activity-date-picker').children(`option[value='?timeframe=${getUrlParameter('timeframe')}']`).prop('selected','selected')
  }

  $('#activity-date-picker').change(function() {
    const value = parseURL($(this).val(), 'per_page')
    const redirect_to = `${window.location.protocol}//${window.location.host}${window.location.pathname}${value}`
    window.location = redirect_to
  })

  if (getUrlParameter('per_page') !== '') {
    $('#table-show-amount').children(`option[value='?per_page=${getUrlParameter('per_page')}']`).prop('selected','selected')
  }

  $('#table-show-amount').change(function() {
    const value = parseURL($(this).val(), 'timeframe')
    const redirect_to = `${window.location.protocol}//${window.location.host}${window.location.pathname}${value}`
    window.location = redirect_to
  })
})

function parseURL(value, extra) {
  if (getUrlParameter('page') !== '') {
    value += `&page=${getUrlParameter('page')}`
  }
  if (getUrlParameter('search') !== '') {
    value += `&search=${getUrlParameter('search')}`
  }
  if (getUrlParameter(extra) !== '') {
    value += `&${extra}=${getUrlParameter(extra)}`
  }
  return value
}

function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
    const regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
    const results = regex.exec(location.search)
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '))
}
