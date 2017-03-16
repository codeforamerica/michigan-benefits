require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MichiganPrototype
  class Application < Rails::Application
    config.action_controller.action_on_unpermitted_parameters = :raise

    # Project configuration
    config.site_name = "Michigan Prototype"
    config.project_description = ""
  end
end
