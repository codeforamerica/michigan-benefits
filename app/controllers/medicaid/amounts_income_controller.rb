# frozen_string_literal: true

module Medicaid
  class AmountsIncomeController < MedicaidStepsController
    private

    def existing_attributes
      HashWithIndifferentAccess.new(income_attributes)
    end

    def income_attributes
      {
        unemployment_income: current_application.unemployment_income,
        self_employed_monthly_income:
        current_application.self_employed_monthly_income,
      }.merge(employed_monthly_income_attributes)
    end

    def employed_monthly_income_attributes
      {}.tap do |income_hash|
        current_application.number_of_jobs.times do |count|
          income_hash["employed_monthly_income_#{count}"] =
            current_application.employed_monthly_income[count]
        end
      end
    end

    def skip?
      not_employed? && not_self_employed? && not_receiving_unemployment?
    end

    def not_employed?
      !current_application&.employed?
    end

    def not_self_employed?
      !current_application&.self_employed?
    end

    def not_receiving_unemployment?
      !current_application&.income_unemployment?
    end
  end
end
