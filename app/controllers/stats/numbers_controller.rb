module Stats
  class NumbersController < ApplicationController
    http_basic_authenticate_with(
      name: Rails.application.secrets.basic_auth_user,
      password: Rails.application.secrets.basic_auth_password,
    )

    def index
      snap_apps = SnapApplication.signed
      medicaid_apps = MedicaidApplication.signed
      common_apps = CommonApplication.signed

      @snap_count = snap_apps.count
      @medicaid_count = medicaid_apps.count
      @combined_count = common_apps.count
      @total_apps_count = @snap_count + @medicaid_count + @combined_count

      @snap_people_count = snap_apps.joins(:members).count
      @medicaid_people_count = medicaid_apps.joins(:members).count
      @combined_people_count = common_apps.joins(:members).count
      @total_people_count = @snap_people_count + @medicaid_people_count + @combined_people_count

      @snap_only_count = common_apps.applying_for_food_only.count
      @medicaid_only_count = common_apps.applying_for_healthcare_only.count
      @snap_and_medicaid_count = common_apps.applying_for_food_and_healthcare.count

      snap_last_thirty = snap_apps.where("created_at > ?", 30.days.ago)
      @snap_median = MedianTimeToCompleteCalculator.new(snap_last_thirty).run

      medicaid_last_thirty = medicaid_apps.where("created_at > ?", 30.days.ago)
      @medicaid_median = MedianTimeToCompleteCalculator.new(medicaid_last_thirty).run

      combined_last_thirty = common_apps.where("created_at > ?", 30.days.ago)
      @combined_median = MedianTimeToCompleteCalculator.new(combined_last_thirty).run

      render :index
    end
  end
end
