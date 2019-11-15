class SaveRequestController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    campaign = params[:campaign]
    app = params[:app]
    if request.headers['Content-Type'] == 'application/json' || valid_json?(request.body.read)
      data = request.body.read
    else
      params.delete :controller
      params.delete :action
      params.delete :slug
      params.delete :campaign
      params.delete :app
      data = params.to_json
    end
    if data.present?
      SaveRequest.perform_async(data, campaign, app)
      render :json => {:status => 200}
    else
      render :json => {:status => 400}
    end
  end
end
