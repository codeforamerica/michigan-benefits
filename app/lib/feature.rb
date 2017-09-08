# frozen_string_literal: true

class Feature
  def self.enabled?(feature)
    ENV["#{feature}_ENABLED"] == "true"
  end
end
