# frozen_string_literal: true

module Medicaid
  class IncomeJobNumber < Step
    step_attributes(:number_of_jobs)

    validates :number_of_jobs,
      presence: { message: "Make sure to answer this question" }
  end
end
