require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CitizenRailsReboot
  class Application < Rails::Application
    config.site_name = ""
    config.project_description = ""
  end
end
