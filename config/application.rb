require_relative "boot"
require_relative "../lib/delayed_job_web_logger"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MichiganBenefits
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.action_controller.action_on_unpermitted_parameters = :raise

    # Project configuration
    config.site_name = "Michigan Benefits"
    config.project_description = ""
    config.active_job.queue_adapter = :delayed_job

    config.filter_parameters += [:ssn]
    config.middleware.insert_after Warden::Manager, DelayedJobWebLogger

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      g.test_framework  :rspec, fixture: true
      g.stylesheets     false
      g.javascripts     false
    end
  end
end
