class Driver
  def run
    home_page = HomePage.new
    home_page.visit
    home_page.submit

    create_account_page = CreateAccountPage.new
    create_account_page.fill_in_required_fields
    create_account_page.submit

    log_in_page = LogInPage.new(
      user_id: create_account_page.user_id,
      password: create_account_page.password,
    )
    log_in_page.submit

    privacy_pin_page = PrivacyPinPage.new
    privacy_pin_page.fill_in_required_fields
    privacy_pin_page.submit

    benefits_overview_page = BenefitsOverviewPage.new
    benefits_overview_page.submit
  end
end
