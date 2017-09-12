# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin
    before_action :default_params

    def authenticate_admin
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV.fetch("ADMIN_USER", "admin") &&
          password == ENV.fetch("ADMIN_PASSWORD", "password")
      end
    end

    def default_params
      params[:order] ||= "created_at"
      params[:direction] ||= "desc"
    end
  end
end
