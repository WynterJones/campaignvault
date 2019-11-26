class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:edit]
  before_action :set_campaign_update, only: [:update, :destroy]
  breadcrumb 'Campaigns', '/campaigns'

  def index
    set_meta_tags title: 'Campaigns'
    @campaigns = Campaign.order(updated_at: :desc).where(user_id: current_user).paginate(page: params[:page], per_page: params[:per_page] || 25)
  end

  def apps
    @campaign = Campaign.find_by(slug: params[:campaign])
    set_meta_tags title: @campaign.name
    breadcrumb @campaign.name, ''
    @timeframe = timeframe(params[:timeframe])
    @apps = App.where(campaign_id: @campaign.id).order(id: :desc).all.paginate(page: params[:page], per_page: params[:per_page] || 25)
    @request_activity = Request.where('created_at >= ?', @timeframe).where(campaign_id: @campaign.id).group_by_day(:created_at).count
  end

  def databases
    @campaign = Campaign.find_by(slug: params[:campaign])
    @app = App.find_by(campaign_id: @campaign.id, slug: params[:app])
    @databases = Database.where(app_id: @app.id).order(id: :desc).paginate(page: params[:page], per_page: params[:per_page] || 25)
    set_meta_tags title: @campaign.name
    breadcrumb @campaign.name, ''
    breadcrumb appSingle(@app.name)['displayName'], ''
  end

  def new
    @campaign = Campaign.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @campaign = Campaign.find_by(slug: params[:campaign_slug])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @campaign = Campaign.new(campaign_params)
    @campaign.user_id = current_user.id

    if check_campaign_limit()
      respond_to do |format|
        format.html {redirect_to '/campaigns', notice: "Limited Reached: You have hit your Limit of #{current_user.campaign_limit} Campaigns" }
      end
    else
      respond_to do |format|
        if @campaign.save
          url = "/campaigns/#{@campaign.slug}"
          format.html { redirect_to url, notice: 'Campaign was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end
  end

  def update
    url = "/campaigns"
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to url, notice: 'Campaign was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
    end
  end

  private

    def set_campaign
      @campaign = Campaign.find_by slug: params[:slug]
    end

    def set_campaign_update
      @campaign = Campaign.find params[:slug]
    end

    def campaign_params
      params.require(:campaign).permit(:name, :description, :apps)
    end
end
