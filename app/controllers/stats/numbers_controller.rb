module Stats
  class NumbersController < ApplicationController
    http_basic_authenticate_with(
      name: Rails.application.secrets.basic_auth_user,
      password: Rails.application.secrets.basic_auth_password,
    )

    def index
      @snap_count = SnapApplication.signed.count
      @medicaid_count = MedicaidApplication.signed.count

      snap_last_thirty = SnapApplication.signed.where("created_at > ?", 30.days.ago)
      @snap_median = MedianTimeToCompleteCalculator.new(snap_last_thirty).run

      medicaid_last_thirty = MedicaidApplication.signed.where("created_at > ?", 30.days.ago)
      @medicaid_median = MedianTimeToCompleteCalculator.new(medicaid_last_thirty).run

      render :index
    end
  end
end
