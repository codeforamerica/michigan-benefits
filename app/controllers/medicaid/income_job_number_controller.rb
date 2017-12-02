module Medicaid
  class IncomeJobNumberController < MedicaidStepsController
    def update_application
      current_application.primary_member.update!(
        employed_number_of_jobs: step_params[:employed_number_of_jobs],
      )
    end

    private

    def skip?
      multi_member_household? || nobody_employed?
    end

    def existing_attributes
      HashWithIndifferentAccess.new(employed_number_of_jobs: number_of_jobs)
    end

    def number_of_jobs
      if current_application.primary_member.employed_number_of_jobs&. > 4
        4
      else
        current_application.primary_member.employed_number_of_jobs
      end
    end

    def nobody_employed?
      !current_application&.anyone_employed?
    end
  end
end
