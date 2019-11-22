class SaveRequest
  include Sidekiq::Worker

  def perform(data, campaign_slug, app_slug, database_slug)
    if data.present?
      newhash = {}
      newarray = []
      data.each do |value|
        if value[0].present?
          newvalue = value[0].dup
          if newvalue.include?('__')
            newvalue = newvalue.gsub! '__', '.'
          end
          newhash[newvalue] = value[1]
          newarray.push(value[1]) if value[1].present?
        end
      end
      campaign = Campaign.find_by_slug(campaign_slug)
      app = App.find_by(campaign_id: campaign.id, slug: app_slug)
      database = Database.find_by(app_id: app.id, slug: database_slug)
      Request.create(data: newhash, values: newarray, database_id: database.id)
      if database.connected == false
        database.connected = true
        database.save
      end
    else
      puts 'Error: Output from request was blank!'
    end
  end
end
