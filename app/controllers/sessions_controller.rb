class SessionsController < Devise::SessionsController
  def new
    set_meta_tags title: 'Login'
    is_license_valid = checkLicense()
    if is_license_valid == false
      redirect_to '/welcome'
    else
      super
    end
  end
end
