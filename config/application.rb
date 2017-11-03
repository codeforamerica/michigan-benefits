require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module MichiganBenefits
  class Application < Rails::Application
    config.action_controller.action_on_unpermitted_parameters = :raise

    # Project configuration
    config.site_name = "Michigan Benefits"
    config.project_description = ""
    config.active_job.queue_adapter = :delayed_job

    config.autoload_paths << Rails.root.join("app/steps")
    config.filter_parameters += [:last_four_ssn]
    config.autoload_paths << Rails.root.join("lib")
  end
end
