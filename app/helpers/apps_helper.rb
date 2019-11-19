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
end
