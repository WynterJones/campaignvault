class SaveRequest
  include Sidekiq::Worker

  def perform(data, campaign_slug, app_slug, database_slug)
    if data.present?
      newhash = {}
      data.each do |value|
        if value[0].present?
          newvalue = value[0].dup
          if newvalue.include?('__')
            newvalue = newvalue.gsub! '__', '.'
          end
          newhash[newvalue] = value[1]
        end
      end
      Request.create(data: newhash.to_json, database_id: database.id)

      campaign = Campaign.find_by_slug(campaign_slug)
      app = App.find_by(campaign_id: campaign.id)
      if app.connected == false
        app.connected = true
        app.save
      end
      puts 'Wabble!', Redis.new.pubsub("channels", "action_cable/*").count
      requests = Request.where(app_id: app.id, campaign_id: campaign.id)
      ActionCable.server.broadcast 'room_channel',
          type: 'dashboard',
          total: Request.all.count,
          graph: Request.where('created_at >= ?', 30.days.ago).group_by_day(:created_at).count
      ActionCable.server.broadcast 'room_channel',
          type: 'app',
          name: app.name,
          rowJSON: newhash.to_json,
          table_columns: app.table_columns,
          total: requests.count,
          graph: requests.where('created_at >= ?', 30.days.ago).group_by_day(:created_at).count
    else
      puts 'Error: Output from request was blank!'
    end
  end
end
