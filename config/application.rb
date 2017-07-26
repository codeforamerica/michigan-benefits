# frozen_string_literal: true

require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module MichiganPrototype
  class Application < Rails::Application
    config.action_controller.action_on_unpermitted_parameters = :raise

    # Project configuration
    config.site_name = "Michigan Assistance Programs"
    config.project_description = ""

    config.autoload_paths << Rails.root.join("app/steps")
    config.autoload_paths << Rails.root.join("app/questions")
  end
end
