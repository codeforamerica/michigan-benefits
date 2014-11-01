class LoggedOutController < ApplicationController
  skip_before_filter :require_login
  layout 'layouts/logged_out'

  def index
  end

  def not_found
    redirect_to root_url
  end
end
