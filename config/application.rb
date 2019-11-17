require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Campaignvault
  class Application < Rails::Application
    config.load_defaults 6.0
    require "action_view/component/base"
  end
end
