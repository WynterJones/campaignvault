class AppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app, only: [:edit]
  before_action :set_app_update, only: [:update, :destroy]
  breadcrumb 'Apps', ''

  def edit
    set_meta_tags title: 'Edit App'
  end

  def update
    respond_to do |format|
      if @app.update(app_params)
        format.html { redirect_to "/campaigns/#{Campaign.find(@app.campaign_id).slug}/#{@app.slug}", notice: 'App was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @app.destroy
    respond_to do |format|
      format.html { redirect_to '/', notice: 'App was successfully deleted.' }
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
