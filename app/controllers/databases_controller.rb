class DatabasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, except: [:destroy, :update]
  before_action :set_app, except: [:destroy, :update]
  before_action :check_user_id

  def index
    breadcrumb 'Campaigns', campaigns_path
    breadcrumb @campaign.name, campaign_path(@campaign.slug)
    breadcrumb @app.name.capitalize, ''
    set_meta_tags title: "#{@app.name.capitalize} Databases"
    @databases = @app.databases.order(id: :asc).paginate(page: params[:page], per_page: params[:per_page] || 25)
  end

  def new
    @database = Database.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @database = Database.find_by(slug: params[:database_slug], app_id: @app.id)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @database = Database.new(database_params)
    @database.app_id = @app.id
    @database.user_id = current_user.id

    url = "/campaigns/#{@campaign.slug}/#{@app.slug}"
    if check_database_limit()
      respond_to do |format|
        format.html {redirect_to url, notice: "Limited Reached: You have hit your Limit of #{current_user.database_limit} Databases" }
      end
    else
      respond_to do |format|
        if @database.save
          format.html { redirect_to url, notice: 'Database was successfully created.' }
        else
          format.html { redirect_to url, notice: 'Error: Database was not created.' }
        end
      end
    end
  end

  def update
    @campaign = Campaign.find(params[:campaign_slug])
    @app = App.find_by(id: params[:app_slug], campaign_id: @campaign.id)
    @database = Database.find_by(id: params[:slug], app_id: @app.id)
    url = "/campaigns/#{@campaign.slug}/#{@app.slug}/#{@database.slug}"
    respond_to do |format|
      if @database.update(database_params)
        format.html { redirect_to url, notice: 'Database was successfully updated.' }
      else
        puts @database.errors.inspect
        format.html { redirect_to url, notice: "Error: #{@database.errors.messages}" }
      end
    end
  end

  def destroy
    @database = Database.find(params[:slug])
    @database.destroy
    @campaign = Campaign.find(params[:campaign_slug])
    @app = App.find_by(id: params[:app_slug], campaign_id: @campaign.id)
    url = "/campaigns/#{@campaign.slug}/#{@app.slug}"
    respond_to do |format|
      format.html { redirect_to url, notice: 'Database was successfully deleted.' }
    end
  end

  private

    def set_campaign
      @campaign = Campaign.find_by(slug: params[:campaign_slug])
    end

    def set_app
      @app = App.includes(:databases).find_by(slug: params[:app_slug], campaign_id: @campaign.id)
    end

    def check_user_id
      if @campaign.user_id != current_user.id
        redirect_to '/campaigns'
      end
    end

    def database_params
      params.require(:database).permit(:name, :table_columns, :stats)
    end
end
