# frozen_string_literal: true

module Medicaid
  class IncomeJobNumberController < MedicaidStepsController
    private

    def existing_attributes
      HashWithIndifferentAccess.new(number_of_job_attributes)
    end

    def number_of_job_attributes
      { number_of_jobs: number_of_jobs }
    end

    def number_of_jobs
      if current_application.number_of_jobs&. > 4
        4
      else
        current_application.number_of_jobs
      end
    end

    def skip?
      multi_member_household? || not_employed?
    end

    def multi_member_household?
      current_application.members.count != 1
    end

    def not_employed?
      !current_application&.employed?
    end
  end
end
