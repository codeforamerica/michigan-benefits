# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin_user!
    before_action :default_params
    around_action :add_tags_to_logs

    def default_params
      params[:order] ||= "created_at"
      params[:direction] ||= "desc"
    end

    def add_tags_to_logs
      user_email = current_admin_user.email
      Rails.logger.tagged(user_email) { yield }
    end

    def current_application; end
  end
end
