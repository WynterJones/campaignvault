class DatabasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_database, only: [:edit, :index]
  before_action :set_database_update, only: [:update, :create, :destroy]


  def index
    breadcrumb 'Campaigns', ''
    breadcrumb @campaign.name, ''
    breadcrumb appSingle(@app.name)['displayName'], ''
  end

  def edit
    set_meta_tags title: 'Edit Database'
  end

  def create
    if database_params['name'].present?
      Database.create(name: database_params['name'])
    end
    url = "/campaigns/#{@campaign.slug}/#{@app.slug}/#{@database.slug}"
    format.html { redirect_to url, notice: 'Database was successfully created.' }
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

    def set_database
      @campaign = Campaign.find_by slug: params[:campaign]
      @app = App.find_by campaign_id: @campaign.id, slug: params[:app]
      @databases = Database.where(app_id: @app.id).order(id: :desc).paginate(page: params[:page], per_page: params[:per_page] || 25)
    end

    def set_database_update
      @campaign = Campaign.find_by slug: params[:campaign]
      @app = App.find_by campaign_id: @campaign.id, slug: params[:app]
      @database = Database.find_by app_id: @app.id
    end

    def database_params
      params.require(:database).permit(:name, :slug, :table_columns)
    end
end
