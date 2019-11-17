class ApplicationController < ActionController::Base
  layout :layout_by_resource
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper
  include LicenseHelper
  include JsonHelper
  include TableHelper
  include AppsHelper

  breadcrumb 'Dashboard', :root_path

  private

    def layout_by_resource
      if devise_controller?
        if controller_name === 'registrations' && controller_action === 'edit'
          "application"
        else
          "devise"
        end
      else
        "application"
      end
    end
end
