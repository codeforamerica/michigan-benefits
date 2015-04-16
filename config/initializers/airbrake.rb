Airbrake.configure do |config|
  config.project_id = ENV['AIRBRAKE_PROJECT_ID']  # needed for JS error reporting
  config.api_key = ENV['AIRBRAKE_API_KEY']
  config.environment_name = ENV['AIRBRAKE_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV']
end

if Rails.env.production?
  if ENV['AIRBRAKE_API_KEY'].blank?
    Rails.logger.error '!' * 50
    Rails.logger.error "Error reporting is not set up!  Please set ENV['AIRBRAKE_API_KEY']"
    Rails.logger.error '!' * 50
  elsif ENV['AIRBRAKE_PROJECT_ID'].blank?
    Airbrake.notify(Exception.new("Error reporting for Javascript is not set up!  Please set , ENV['AIRBRAKE_PROJECT_ID'] to the project ID (found in the Airbrake admin interface URL)"))
  end
end

