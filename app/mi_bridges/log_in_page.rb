class LogInPage
  def initialize(user_id:, password:)
    @user_id = user_id
    @password = password
  end

  def visit
    visit url
  end

  def fill_in_required_fields
    fill_in_user_id
    fill_in_password
  end

  def submit
    click_on "User Login"
  end

  private

  attr_reader :user, :password

  def url
    "https://www.mibridges.michigan.gov/access/jsp/access/myAccess/ASLogin.jsp"
  end
end
