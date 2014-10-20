class LoggedOutController < ApplicationController
  skip_before_filter :require_login
  layout 'layouts/raw'

  def index
  end

  def not_found
    redirect_to root_url
  end
end
