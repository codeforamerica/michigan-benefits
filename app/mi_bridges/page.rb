require "capybara/rails"
require Rails.root.join("spec/support/chrome_browser.rb")

class Page
  include Capybara::DSL

  def initialize(snap_application:)
    @snap_application = snap_application
    Capybara.default_driver = :chrome
  end

  private

  attr_reader :snap_application
end
