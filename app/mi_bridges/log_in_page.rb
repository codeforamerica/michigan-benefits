class LogInPage < Page
  def initialize(user_id:, password:)
    @user_id = user_id
    @password = password
    Capybara.default_driver = :chrome
  end

  def fill_in_required_fields
    fill_in "User ID", with: user_id
    sleep 1
    fill_in "Password", with: password
    sleep 1
  end

  def submit
    click_on "User Login"
  end

  private

  attr_reader :user_id, :password
end
