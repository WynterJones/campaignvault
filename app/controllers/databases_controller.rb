class DatabasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app, only: [:edit]
  before_action :set_app_update, only: [:update, :destroy]
  breadcrumb 'Databases', ''

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
      @database = Database.find_by slug: params[:slug]
    end

    def set_app_update
      @database = Database.find params[:slug]
    end

    def app_params
      params.require(:app).permit(:name, :slug, :structure, :column_keys, :table_columns)
    end
end
