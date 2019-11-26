class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: [:welcome]

  def index
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

end
