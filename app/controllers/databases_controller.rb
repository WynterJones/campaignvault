class DatabasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign
  before_action :set_app
  before_action :set_database, only: [:edit]

  def index
    breadcrumb 'Campaigns', campaigns_path
    breadcrumb @campaign.name, campaign_path(@campaign.slug)
    breadcrumb appSingle(@app.name)['displayName'], ''
    @databases = @app.databases.paginate(page: params[:page], per_page: params[:per_page] || 25)
  end

  def new
    @database = Database.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    set_meta_tags title: 'Edit Database'
  end

  def create
    @database = Database.new(database_params)
    @database.app_id = @app.id
    puts database_params
    puts 'hey'
    puts @database.inspect
    respond_to do |format|
      if @database.save
        format.html { redirect_to '/', notice: 'Database was successfully created.' }
        format.js { redirect_to '/', notice: 'Database was successfully created.' }
      else
        format.html { redirect_to '/', notice: 'Erro was successfully errorred.' }
        format.js { redirect_to '/', notice: 'Erro was successfully created.' }
      end
    end
  end

  def update
    respond_to do |format|
      if @database.update(database_params)
        url = "/campaigns/#{@campaign.slug}/#{@app.slug}/#{@database.slug}"
        format.html { redirect_to url, notice: 'Database was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @database.destroy
    respond_to do |format|
      format.html { redirect_to '/', notice: 'Database was successfully deleted.' }
    end
  end

  private

    def set_campaign
      @campaign = Campaign.find_by(slug: params[:campaign_slug])
    end

    def set_app
      @app = App.includes(:databases).find_by(slug: params[:app_slug], campaign_id: @campaign.id)
    end

    def database_params
      params.require(:database).permit(:name, :slug, :table_columns)
    end
end
