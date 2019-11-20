module AppsHelper
  def appsJSON
    return JSON.parse(File.read('public/apps.json'))
  end

  def appSingle(name)
    data = appsJSON()['apps']
    index = data.find_index{ |item| item['name'] == name }
    if index.present?
      return data[index]
    else
      return 'Unknown'
    end
  end

  def all_apps_as_options()
    data = appsJSON()['apps']
    options = ''
    data.each do |value|
      options += "<option value='#{value['displayName']}' data-zapierapi='#{value['zapierAPI']}' data-dbs='#{value['databases']}'>#{value['displayName']}</option>"
    end
    return options.html_safe
  end
end
