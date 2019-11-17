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
      data = params.to_enum.to_h
    end
    if data.present?
      data = data.sort_by { |key, val| key }
      SaveRequest.perform_async(data, campaign, app)
      render :json => {:status => 200}
    else
      render :json => {:status => 400}
    end
  end

  def my_sort(data, attribute, asc = true)
    # Convert to string because of possible nil values
    sorted = data.sort_by { |elem| elem[attribute].to_s }
    asc ? sorted : sorted.reverse
  end
end
