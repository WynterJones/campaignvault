class SaveRequest
  include Sidekiq::Worker

  def perform(data, campaign, slug)
    if data.present?
      newhash = {}
      JSON.parse(data).each do |value|
        newvalue = value[0].dup
        newvalue = newvalue.gsub! '__', '.'
        newhash[newvalue] = value[1]
      end
      theCampaign = Campaign.find_by_slug(campaign)
      app = App.find_by(slug: slug, campaign_id: theCampaign.id)
      Request.create(body: newhash.to_json, app_id: app.id, campaign_id: theCampaign.id)
    else
      puts 'Error: Output from request was blank!'
    end
  end
end
