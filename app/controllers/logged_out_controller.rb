class LoggedOutController < ApplicationController
  skip_before_filter :require_login

  def index
  end
end
