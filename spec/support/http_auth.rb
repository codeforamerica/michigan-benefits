module HttpAuthHelper
  def http_login
    username = Rails.application.config.site_username
    password = Rails.application.config.site_password
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  end

  def site_login_required?
    Rails.application.config.require_site_login
  end

  def site_login_if_necessary
    http_login if site_login_required?
  end
end
