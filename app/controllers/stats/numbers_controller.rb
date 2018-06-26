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

      @snap_median = MedianTimeToCompleteCalculator.new(snap_apps).run
      @medicaid_median = MedianTimeToCompleteCalculator.new(medicaid_apps).run
      @integrated_median = MedianTimeToCompleteCalculator.new(common_apps).run

      combined_last_thirty = common_apps.where("common_applications.created_at > ?", 30.days.ago)
      @snap_only_median = MedianTimeToCompleteCalculator.
        new(combined_last_thirty.applying_for_food_only).
        run

      @medicaid_only_median = MedianTimeToCompleteCalculator.
        new(combined_last_thirty.applying_for_healthcare_only).
        run

      @snap_and_medicaid_median = MedianTimeToCompleteCalculator.
        new(combined_last_thirty.applying_for_food_and_healthcare).
        run

      render :index
    end
  end
end
