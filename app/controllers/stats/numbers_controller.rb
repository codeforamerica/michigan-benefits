module Stats
  class NumbersController < ApplicationController
    http_basic_authenticate_with(
      name: Rails.application.secrets.basic_auth_user,
      password: Rails.application.secrets.basic_auth_password
    )

    def index
      @snap_count = SnapApplication.count
      @medicaid_count = MedicaidApplication.count

      render :index
    end
  end
end
