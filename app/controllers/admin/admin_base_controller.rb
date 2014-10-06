class Admin::AdminBaseController < ApplicationController
  before_filter :require_admin

  layout "raw"
end
