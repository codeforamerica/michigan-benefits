module Medicaid
  class IncomeJobNumberController < MedicaidStepsController
    def edit
      @step = step_class.new(employed_number_of_jobs: number_of_jobs)
    end

    private

    def update_application
      member.update!(step_params)
      member.modify_employments
    end

    def member
      current_application.primary_member
    end

    def skip?
      multi_member_household? || nobody_employed?
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
