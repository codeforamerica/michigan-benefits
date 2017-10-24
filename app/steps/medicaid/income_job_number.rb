# frozen_string_literal: true

module Medicaid
  class IncomeJobNumber < Step
    step_attributes(:employed_number_of_jobs)

    validates :employed_number_of_jobs,
      presence: { message: "Make sure to answer this question" }
  end
end
