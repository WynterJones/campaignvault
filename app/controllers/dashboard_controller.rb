class DashboardController < ApplicationController
  before_action :authenticate_user!, except: [:welcome]

  def index
    set_meta_tags title: 'Dashboard'
    @timeframe = timeframe(params[:timeframe])
    apps = App.where(user_id: current_user)
    campaigns = Campaign.where(user_id: current_user.id)
    databases = Database.where(user_id: current_user.id)
    requests = Request.where(user_id: current_user.id)
    @all_requests = number_with_delimiter(requests.where('created_at >= ?', @timeframe).count)
    @all_apps = number_with_delimiter(apps.where('created_at >= ?', @timeframe).count)
    @all_campaigns = number_with_delimiter(campaigns.where('created_at >= ?', @timeframe).count)
    @all_databases = number_with_delimiter(databases.where('created_at >= ?', @timeframe).count)
    @graph_all_activity = requests.where('created_at >= ?', @timeframe).group_by_day(:created_at).count
  end
end
