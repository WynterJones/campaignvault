class SaveRequestController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    campaign_slug = params[:campaign]
    app_slug = params[:app]
    database_slug = params[:database]
    if request.headers['Content-Type'] == 'application/json' || valid_json?(request.body.read)
      data = request.body.read
    else
      params.delete :controller
      params.delete :action
      params.delete :slug
      params.delete :campaign
      params.delete :app
      params.delete :database
      data = params.to_enum.to_h
    end
    if data.present?
      data = data.sort_by { |key, val| key }
      SaveRequest.perform_async(data, campaign_slug, app_slug, database_slug)
      render :json => {:status => 200}
    else
      render :json => {:status => 400}
    end
  end
end
