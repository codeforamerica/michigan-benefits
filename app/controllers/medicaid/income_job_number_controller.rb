# frozen_string_literal: true

module Medicaid
  class IncomeJobNumberController < MedicaidStepsController
    private

    def existing_attributes
      HashWithIndifferentAccess.new(number_of_job_attributes)
    end

    def number_of_job_attributes
      { new_number_of_jobs: number_of_jobs }
    end

    def number_of_jobs
      if current_application.new_number_of_jobs&. > 4
        4
      else
        current_application.new_number_of_jobs
      end
    end

    def skip?
      not_employed?
    end

    def not_employed?
      !current_application&.employed?
    end
  end
end
