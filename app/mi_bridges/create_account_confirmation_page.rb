class CreateAccountConfirmationPage < Page
  def initialize
    Capybara.default_driver = :chrome
  end

  def submit
    sleep 1
    click_on "Click here"
  end
end
