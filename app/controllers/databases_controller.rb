class DatabasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app, only: [:edit, :index]
  before_action :set_app_update, only: [:update, :destroy]


  def index
    breadcrumb 'Campaigns', ''
    breadcrumb @campaign.name, ''
    breadcrumb appSingle(@app.name)['displayName'], ''
  end

  def edit
    set_meta_tags title: 'Edit Database'
  end

  def update
    respond_to do |format|
      if @database.update(app_params)
        url = "/campaigns/#{Campaign.find(@database.campaign_id).slug}/#{App.find(@database.app_id).slug}/#{@database.slug}"
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

    def set_app
      @app = App.find_by slug: params[:app]
      @databases = Database.where(app_id: @app.id).order(id: :desc).paginate(page: params[:page], per_page: params[:per_page] || 25)
      puts @app.inspect
      @campaign = Campaign.find @app.campaign_id
    end

    def set_app_update
      @database = Database.find params[:slug]
    end

    def app_params
      params.require(:app).permit(:name, :slug, :structure, :column_keys, :table_columns)
    end
end
