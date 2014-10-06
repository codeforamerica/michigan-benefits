class LoggedOutController < ApplicationController
  skip_before_filter :require_login
  layout 'layouts/raw'

  def index
  end
end
