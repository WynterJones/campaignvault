class SaveRequest
  include Sidekiq::Worker

  def perform(data, campaign, app)
    if data.present?
      newhash = {}
      JSON.parse(data).each do |value|
        newvalue = value[0].dup
        newvalue = newvalue.gsub! '__', '.'
        newhash[newvalue] = value[1]
      end
      theCampaign = Campaign.find_by_slug(campaign)
      webhook = Webhook.find_by(slug: app, campaign_id: theCampaign.id)
      Request.create(body: newhash.to_json, webhook_id: webhook.id, campaign_id: theCampaign.id)
      if Request.where(webhook_id: webhook.id, campaign_id: theCampaign.id).count == 1
        editWebhook = Webhook.find_by(slug: app, campaign_id: theCampaign.id)
        editWebhook.connected = true
        editedWebhook.save
      end
    else
      puts 'Error: Output from request was blank!'
    end
  end
end
