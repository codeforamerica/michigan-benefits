module Medicaid
  class AmountsIncome < MemberStep
    step_attributes(
      {
        employed_monthly_income: [],
        employed_monthly_employer: [],
        employed_payment_frequency: [],
      },
      :self_employed_monthly_income,
      :unemployment_income,
      :member_id,
    )

    delegate(
      :employed_number_of_jobs,
      :receives_unemployment_income?,
      :self_employed?,
      to: :member,
    )

    validate :incomes
    validate :employer_names
    validate :payment_frequencies
    validate :unemployment_income_provided
    validate :self_employment_income

    private

    def incomes
      return true if employed_number_of_jobs == employed_monthly_income&.count
      errors.add(:incomes_missing, "Make sure all jobs have an income amount")
    end

    def employer_names
      return true if employed_number_of_jobs == employed_monthly_employer&.count
      errors.add(:incomes_missing, "Make sure all jobs have an employer name")
    end

    def payment_frequencies
      if employed_number_of_jobs == employed_payment_frequency&.count
        return true
      end

      errors.add(
        :incomes_missing,
        "Make sure all jobs have a payment frequency",
      )
    end

    def unemployment_income_provided
      return true if unemployed_and_unemployment_income_provided?
      errors.add(:incomes_missing, "Make sure to provide unemployment income")
    end

    def unemployed_and_unemployment_income_provided?
      !receives_unemployment_income? ||
        (receives_unemployment_income? && unemployment_income.present?)
    end

    def self_employment_income
      return true if self_employment_income_provided?
      errors.add(:incomes_missing, "Make sure to provide unemployment income")
    end

    def self_employment_income_provided?
      !self_employed? ||
        (self_employed? && self_employed_monthly_income.present?)
    end
  end
end
