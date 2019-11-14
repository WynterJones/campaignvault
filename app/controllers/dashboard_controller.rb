class DashboardController < ApplicationController
  before_action :authenticate_user!, except: [:welcome]

  def welcome
    set_meta_tags title: 'Welcome!'
    is_license_valid = checkLicense()
    if is_license_valid == true
      @successHeadline = 'Congratulations'
      @successMessage = '<strong><i class="far fa-check-circle mr-1"></i> Successfully Installed WebhookDB onto Heroku</strong>'
      @successShow = ''
    else
      @successHeadline = 'Not Valid License Key'
      @successMessage = '<strong><i class="far fa-check-circle mr-1"></i> Oh No, Looks Like Your License Key Failed :(</strong><br /><a href="https://webhookdb.com/" class="btn btn-success btn-lg mt-3">Buy a License Key</a>'
      @successShow = 'display: none'
    end
    render layout: 'devise'
  end

  def index
    set_meta_tags title: 'Dashboard'
    @timeframe = timeframe(params[:timeframe])
    requests = Request.all
    tags = Tag.all
    webhooks = Webhook.all
    @all_requests = number_with_delimiter(requests.where('created_at >= ?', @timeframe).count)
    @all_tags = number_with_delimiter(tags.where('created_at >= ?', @timeframe).count)
    @all_webhooks = number_with_delimiter(webhooks.where('created_at >= ?', @timeframe).count)
    @all_requests_total = number_with_delimiter(requests.count)
    @all_tags_total = number_with_delimiter(tags.count)
    @all_webhooks_total = number_with_delimiter(webhooks.count)
    @all_activity = requests.where('created_at >= ?', @timeframe).group_by_day(:created_at).count
  end
end
