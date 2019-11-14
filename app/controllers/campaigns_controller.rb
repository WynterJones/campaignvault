class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit]
  before_action :set_campaign_update, only: [:update, :destroy]
  breadcrumb 'Campaigns', '/campaigns'

  def index
    set_meta_tags title: 'Campaigns'
    @campaigns = Campaign.all.paginate(page: params[:page], per_page: params[:per_page] || 25)
  end

  def show
    set_meta_tags title: @campaign.name
    breadcrumb @campaign.name, ''
    @timeframe = timeframe(params[:timeframe])
    @apps = App.where(campaign_id: @campaign.id).order(id: :desc).all.paginate(page: params[:page], per_page: params[:per_page] || 25)
    @request_activity = Request.where('created_at >= ?', @timeframe).where(campaign_id: @campaign.id).group_by_day(:created_at).count
  end

  def new
    set_meta_tags title: 'New Campaign'
    breadcrumb 'New', ''
    @campaign = Campaign.new
  end

  def edit
    set_meta_tags title: "Edit Campaign"
    breadcrumb @campaign.name, ''
    breadcrumb 'Edit', ''
  end

  def create
    @campaign = Campaign.new(campaign_params)

    respond_to do |format|
      if @campaign.save
        apps = params[:apps].split(',')
        apps.each do |app|
          puts app
          App.create(campaign_id: @campaign.id, name: app, slug: app.parameterize, structure: appSingle(app)['structure'], column_keys: appSingle(app)['column_keys'])
        end
        format.html { redirect_to "/campaigns/#{@campaign.slug}", notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to "/campaigns/#{@campaign.slug}", notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
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
