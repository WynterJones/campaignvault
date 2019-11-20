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
  },

  newSelector: (element) => {
    const name = $(element).val()
    const zapierapi = $(element).find('option:selected').attr('data-zapierapi')
    const databases = JSON.parse($(element).find('option:selected').attr('data-dbs'))
    $('#apps_database_list').fadeIn()
    $('#apps_database_list .change_app_name').text(name)
    $('#apps_database_list h4 img').attr('src', `/apps/${name}.png`)
    $('#change_app_count').text(databases.length)
    $('#change_app_db_list').html('')
    $('#app_name').val(name)
    $('#app_zapierapi').val(zapierapi)
    $('#app_db_list').val(databases)
    databases.forEach(function(value) {
      $('#change_app_db_list').append(`<li>${value}</li>`)
    })
  }

}

module.exports = apps
