module Medicaid
  class IncomeJobNumberController < MedicaidStepsController
    def update
      @step = step_class.new(step_params)

      if @step.valid?
        current_application.primary_member.update!(number_of_job_attributes)
        redirect_to(next_path)
      else
        render :edit
      end
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

    def number_of_job_attributes
      { employed_number_of_jobs: step_params[:employed_number_of_jobs] }
    end

    def nobody_employed?
      !current_application&.anyone_employed?
    end
  end
end
