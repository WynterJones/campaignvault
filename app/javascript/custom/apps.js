'use strict'

const apps = {

  select: (element) => {
    let type = ''
    $(element).toggleClass('card-app-selected')
    $('.card-app-selected').each(function() {
      type += `,${$(element).attr('data-type')}`
    })
    $('#apps-input').val(type.replace(',', ''))
  }

}

module.exports = apps
