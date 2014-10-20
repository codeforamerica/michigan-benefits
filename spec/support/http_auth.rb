module HttpAuthHelper
  def http_login
    http_login_headers.each do |k, v|
      request.env[k] = v
    end
  end

  def http_login_headers
    return {} unless site_login_required?
    username = Rails.application.config.site_username
    password = Rails.application.config.site_password
    { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
  end

  def site_login_required?
    Rails.application.config.require_site_login
  end

  # XXX: request.env doesn't work in request specs
  module RequestOverrides
    def get(uri, params = {}, session = {})
      super uri, params, http_login_headers.merge(session)
    end
  end
end
