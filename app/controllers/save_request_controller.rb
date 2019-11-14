class SaveRequestController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    if request.headers['Content-Type'] == 'application/json' || valid_json?(request.body.read)
      data = request.body.read
    else
      params.delete :controller
      params.delete :action
      params.delete :slug
      data = params.to_json
    end
    if data.present?
      SaveRequest.perform_async(data, params[:campaign], params[:app])
      render :json => {:status => 200}
    else
      render :json => {:status => 400}
    end
  end
end
