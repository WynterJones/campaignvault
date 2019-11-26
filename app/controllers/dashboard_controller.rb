class DashboardController < ApplicationController
  before_action :authenticate_user!, except: [:welcome]

  def welcome
    set_meta_tags title: 'Welcome!'
    is_license_valid = checkLicense()
    if is_license_valid == true
      @successHeadline = 'Congratulations'
      @successMessage = '<strong><i class="far fa-check-circle mr-1"></i> Successfully Installed CampaignVault onto Heroku</strong>'
      @successShow = ''
    else
      @successHeadline = 'Not Valid License Key'
      @successMessage = '<strong><i class="far fa-check-circle mr-1"></i> Oh No, Looks Like Your License Key Failed :(</strong><br /><a href="https://campaignvault.com/" class="btn btn-success btn-lg mt-3">Buy a License Key</a>'
      @successShow = 'display: none'
    end
    render layout: 'devise'
  end

  def index
    set_meta_tags title: 'Dashboard'
    @timeframe = timeframe(params[:timeframe])
    requests = Request.where(user_id: current_user)
    apps = App.where(user_id: current_user)
    campaigns = Campaign.where(user_id: current_user)
    databases = Database.where(user_id: current_user)
    @all_requests = number_with_delimiter(requests.where('created_at >= ?', @timeframe).count)
    @all_apps = number_with_delimiter(apps.where('created_at >= ?', @timeframe).count)
    @all_campaigns = number_with_delimiter(campaigns.where('created_at >= ?', @timeframe).count)
    @all_databases = number_with_delimiter(databases.where('created_at >= ?', @timeframe).count)
    @all_activity = requests.where('created_at >= ?', @timeframe).group_by_day(:created_at).count
  end

end
