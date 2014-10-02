module HttpAuthHelper
  def http_login
    username = Rails.application.config.beta_username
    password = Rails.application.config.beta_password
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  end

  def site_in_beta?
    Rails.application.config.require_beta_login
  end

  def beta_login_if_necessary
    http_login if site_in_beta?
  end
end
