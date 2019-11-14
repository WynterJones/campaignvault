class RequestsController < ApplicationController
  before_action :authenticate_user!
  breadcrumb 'Campaigns', :campaigns_url

  def show
    @settings = Setting.find_by_user_id(current_user.id)
    @timeframe = timeframe(params[:timeframe])
    @webhook = Webhook.order(id: :desc).find_by(slug: params[:id])
    @request_activity = Request.where('created_at >= ?', @timeframe).where(webhook_id: @webhook.id).group_by_day(:created_at).count

    @campaign = Campaign.find(@webhook.campaign_id)
    breadcrumb @campaign.name, "/campaigns/#{@campaign.slug}"
    breadcrumb appSingle(@webhook.name)['displayName'], ''

    set_meta_tags title: "#{appSingle(@webhook.name)['displayName']} in #{@campaign.name}"

    @search = params["search"]
    all_requests = Request.order(id: :desc).paginate(page: params[:page], per_page: params[:per_page] || 25)

    if @search.present?
      @requests = all_requests.where(webhook_id: @webhook.id).where("body ILIKE ?", "%#{@search}%")
      @search_count = number_with_delimiter(@requests.count)
    else
      @requests = all_requests.where('created_at >= ?', @timeframe).where(webhook_id: @webhook.id)
    end

    buildTable(@webhook, @settings)
  end

  def delete
    Request.delete(params[:delete_ids].split(','))
    respond_to do |format|
      format.html { redirect_to params[:redirect], notice: 'Requests were successfully deleted.' }
    end
  end
end
