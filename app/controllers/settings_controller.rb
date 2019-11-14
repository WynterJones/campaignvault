class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_settings, only: [:index, :update]
  breadcrumb 'Settings', ''

  def index
    set_meta_tags title: 'Settings'
  end

  def update
    respond_to do |format|
      if @settings.update(settings_params)
        format.html { redirect_to '/settings', notice: 'Setting was successfully updated.' }
      else
        format.html { render '/settings' }
      end
    end
  end

  private

    def set_settings
      @settings = Setting.find_by_user_id(current_user.id)
    end

    def settings_params
      params.require(:settings).permit(:theme, :date_format, :tooltip, :timezone)
    end
end
