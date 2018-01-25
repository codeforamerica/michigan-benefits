class GateKeeper
  def self.feature_enabled?(feature)
    ENV["#{feature}_ENABLED"] == "true"
  end

  def self.demo_environment?
    if ENV["DEMO_SITE"] == "true"
      true
    elsif Rails.env.staging?
      true
    else
      false
    end
  end
end
