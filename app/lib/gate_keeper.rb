class GateKeeper
  def self.feature_enabled?(feature)
    ENV["#{feature}_ENABLED"] == "true"
  end

  def self.application_routing_environment
    ENV.fetch("APP_RELEASE_STAGE", "development")
  end

  def self.demo_environment?
    application_routing_environment == "staging"
  end
end
