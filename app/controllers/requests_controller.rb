class RequestsController < ApplicationController
  before_action :authenticate_user!
  breadcrumb 'Campaigns', :campaigns_url

  def index
    @settings = Setting.find_by_user_id(current_user.id)
    @timeframe = timeframe(params[:timeframe])
    @campaign = Campaign.find_by(slug: params[:campaign_slug])
    @app = App.find_by(slug: params[:app_slug], campaign_id: @campaign.id)
    @database = Database.find_by(slug: params[:database_slug], app_id: @app.id)
    @stats = JSON.parse(@database.stats)
    @request_activity = Request.where('created_at >= ?', @timeframe).where(database_id: @database.id).group_by_day(:created_at).count
    @request_count = Request.where(database_id: @database.id).count

    breadcrumb @campaign.name, "/campaigns/#{@campaign.slug}"
    breadcrumb @app.name, "/campaigns/#{@campaign.slug}/#{@app.slug}"
    breadcrumb @database.name, ''

    set_meta_tags title: "#{@app.name.titleize} in #{@campaign.name}"

    @search = params["search"]
    all_requests = Request.order(id: :desc).paginate(page: params[:page], per_page: params[:per_page] || 25)

    if @search.present?
      # TODO FIX
      @requests = Request.where(database_id: @database.id).where(Arel.sql("data->>'currency' = '#{@search}'")).paginate(page: params[:page], per_page: params[:per_page] || 25)
      @search_count = Request.where(database_id: @database.id).where(Arel.sql("data->>'currency' = '#{@search}'")).count
    else
      @requests = all_requests.where('created_at >= ?', @timeframe).where(database_id: @database.id)
    end

    puts @requests.inspect

    buildTable(@database, @settings, @requests, @request_count)
  end

  def delete
    Request.delete(params[:delete_ids].split(','))
    respond_to do |format|
      format.html { redirect_to params[:redirect], notice: 'Requests were successfully deleted.' }
    end
  end

  def new_total
    @campaign = Campaign.find_by(slug: params[:campaign_slug])
    @app = App.find_by(slug: params[:app_slug], campaign_id: @campaign.id)
    @database = Database.find_by(slug: params[:database_slug], app_id: @app.id)
    @request = Request.where(database_id: @database.id).select(:data).first
    @stats = JSON.parse(@database.stats)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
