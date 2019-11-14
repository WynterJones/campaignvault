class RegistrationsController < Devise::RegistrationsController
  layout 'application', only: [:edit]

  def edit
    set_meta_tags title: 'Account'
    breadcrumb 'Account', ''
  end

  private

    def after_update_path_for(resource)
      '/account'
    end
end
