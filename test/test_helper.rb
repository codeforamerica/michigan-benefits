ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/mock'

class ActiveSupport::TestCase
  # Add helper methods to be used by all tests here...
  class << self
    alias :context :describe
  end
end

class ActionController::TestCase
  include Sorcery::TestHelpers::Rails::Controller
end
