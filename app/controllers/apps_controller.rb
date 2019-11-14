class AppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app, only: [:show, :edit]
  before_action :set_app_update, only: [:update, :destroy]
  breadcrumb 'Apps', ''

  def index
    set_meta_tags title: 'Manage'
    @apps = App.order(id: :desc).all.paginate(page: params[:page], per_page: params[:per_page] || 25)
  end

  def show
    redirect_to '/apps'
  end

  def new
    set_meta_tags title: 'New App'
    @app = App.new
  end

  def edit
    set_meta_tags title: 'Edit App'
  end

  def create
    @app = App.new(app_params)
    respond_to do |format|
      if @app.save
        format.html { redirect_to apps_url, notice: 'App was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @app.update(app_params)
        format.html { redirect_to apps_url, notice: 'App was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @app.destroy
    respond_to do |format|
      format.html { redirect_to apps_url, notice: 'App was successfully deleted.' }
    end
  end

  private

    def set_app
      @app = App.find_by slug: params[:slug]
    end

    def set_app_update
      @app = App.find params[:slug]
    end

    def app_params
      params.require(:app).permit(:name, :slug, :structure, :column_keys)
    end
end
