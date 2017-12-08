module Medicaid
  class IncomeJobNumberController < MedicaidStepsController
    def update_application
      member.update!(step_params)
      member.modify_employments
    end

    private

    def member
      current_application.primary_member
    end

    def skip?
      multi_member_household? || nobody_employed?
    end

    def existing_attributes
      HashWithIndifferentAccess.new(employed_number_of_jobs: number_of_jobs)
    end

    def number_of_jobs
      if member.employed_number_of_jobs&. > 4
        4
      else
        member.employed_number_of_jobs
      end
    end

    def nobody_employed?
      !current_application.anyone_employed?
    end
  end
end
