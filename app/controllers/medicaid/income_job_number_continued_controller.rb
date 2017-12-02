module Medicaid
  class IncomeJobNumberContinuedController < MedicaidStepsController
    def update_application
      current_application.primary_member.update!(
        employed_number_of_jobs: step_params[:employed_number_of_jobs],
      )
    end

    private

    def skip?
      multi_member_household? ||
        nobody_employed? ||
        current_application.primary_member.employed_number_of_jobs < 4
    end

    def nobody_employed?
      !current_application.anyone_employed?
    end

    def existing_attributes
      HashWithIndifferentAccess.new(
        employed_number_of_jobs:
          current_application.primary_member.employed_number_of_jobs,
      )
    end
  end
end
