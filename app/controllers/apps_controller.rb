class AppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, except: [:update, :destroy]
  before_action :set_app, only: [:edit]
  before_action :set_app_update, only: [:update, :destroy]
  before_action :check_user_id

  def index
    set_meta_tags title: @campaign.name
    breadcrumb 'Campaigns', '/campaigns'
    breadcrumb @campaign.name, campaign_path(@campaign.slug)
    @apps = @campaign.apps.order(updated_at: :desc).paginate(page: params[:page], per_page: params[:per_page] || 25)
  end

  def new
    @app = App.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @app = App.find_by(slug: params[:app_slug], campaign_id: @campaign.id)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @app = App.new(app_params)
    @app.campaign_id = @campaign.id
    @app.user_id = current_user.id
    url = "/campaigns/#{@campaign.slug}"

    if check_app_limit()
      respond_to do |format|
        format.html {redirect_to url, notice: "Limited Reached: You have hit your Limit of #{current_user.app_limit} Apps" }
      end
    else
      respond_to do |format|
        if @app.save
          databases = params[:db_list].split(',')
          databases.each do |database|
            Database.create(app_id: @app.id, name: database, slug: database.parameterize, user_id: current_user.id)
          end
          format.html { redirect_to url, notice: 'App was successfully created.' }
        else
          format.html { redirect_to url, error: 'Error: App was not created.' }
        end
      end
    end
  end

  def update
    url = "/campaigns/#{@campaign.slug}"
    respond_to do |format|
      if @app.update(app_params)
        format.html { redirect_to url, notice: 'App was successfully updated.' }
      else
        format.html { redirect_to url, notice: 'Error: App was not updated.' }
      end
    end
  end

  def destroy
    @app.destroy
    @campaign = Campaign.find(params[:campaign_slug])
    url = "/campaigns/#{@campaign.slug}"
    respond_to do |format|
      format.html { redirect_to url, notice: 'App was successfully deleted.' }
    end
  end

  private

    def set_campaign
      @campaign = Campaign.includes(:apps).find_by(slug: params[:campaign_slug])
    end

    def set_app
      @app = App.find_by(slug: params[:slug], campaign_id: @campaign.id)
    end

    def set_app_update
      @campaign = Campaign.find_by(id: params[:campaign_slug])
      @app = App.find_by(id: params[:slug], campaign_id: @campaign.id)
    end

    def check_user_id
      if @campaign.user_id != current_user.id
        redirect_to '/campaigns'
      end
    end

    def app_params
      params.require(:app).permit(:name, :zapierapi)
    end
end
