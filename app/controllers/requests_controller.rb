class RequestsController < ApplicationController
  before_action :authenticate_user!
  breadcrumb 'Campaigns', :campaigns_url

  def index
    @settings = Setting.find_by_user_id(current_user.id)
    @timeframe = timeframe(params[:timeframe])
    @campaign = Campaign.find_by(slug: params[:campaign_slug])
    @app = App.order(id: :desc).find_by(slug: params[:app_slug], campaign_id: @campaign.id)
    @database = Database.order(id: :desc).find_by(slug: params[:database_slug])
    @request_activity = Request.where('created_at >= ?', @timeframe).where(database_id: @database.id).group_by_day(:created_at).count
    @table_columns = JSON.parse(@database.table_columns)

    breadcrumb @campaign.name, "/campaigns/#{@campaign.slug}"
    breadcrumb appSingle(@app.name)['displayName'], "/campaigns/#{@campaign.slug}/#{@app.slug}"
    breadcrumb @database.name, ''

    set_meta_tags title: "#{appSingle(@app.name)['displayName']} in #{@campaign.name}"

    @search = params["search"]
    all_requests = Request.order(id: :desc).paginate(page: params[:page], per_page: params[:per_page] || 25)

    if @search.present?
      @requests = all_requests.where(database_id: @database.id).where("body ILIKE ?", "%#{@search}%")
      @search_count = number_with_delimiter(@requests.count)
    else
      @requests = all_requests.where('created_at >= ?', @timeframe).where(database_id: @database.id)
    end

    buildTable(@database, @settings)
  end

  def delete
    Request.delete(params[:delete_ids].split(','))
    respond_to do |format|
      format.html { redirect_to params[:redirect], notice: 'Requests were successfully deleted.' }
    end
  end
end
