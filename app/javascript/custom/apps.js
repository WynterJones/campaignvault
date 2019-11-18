'use strict'

const apps = {

  select: (element) => {
    const types = []
    $(element).toggleClass('card-app-selected')
    $('.card-app-selected').each(function() {
      const data_type = $(this).attr('data-type')
      types.push(data_type)
    })
    const all_apps = [...new Set(types)];
    $('#apps-input').val(all_apps.sort())
  }

}

module.exports = apps
