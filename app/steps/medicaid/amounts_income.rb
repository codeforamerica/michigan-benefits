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

    with_options if: :has_jobs? do |employed|
      employed.validate :incomes
      employed.validate :employer_names
      employed.validate :payment_frequencies
    end

    validate :unemployment_income_provided, if: :receives_unemployment_income?
    validate :self_employment_income, if: :self_employed?

    private

    def has_jobs?
      employed_number_of_jobs&.positive?
    end

    def incomes
      return true if job_and_income_counts_match? && present_incomes?
      errors.add(:incomes_missing, "Make sure all jobs have an income amount")
    end

    def job_and_income_counts_match?
      employed_number_of_jobs == employed_monthly_income&.count
    end

    def present_incomes?
      employed_monthly_income&.all?(&:present?)
    end

    def employer_names
      return true if job_and_employer_counts_match? && present_employer_names?
      errors.add(:incomes_missing, "Make sure all jobs have an employer name")
    end

    def job_and_employer_counts_match?
      employed_number_of_jobs == employed_monthly_employer&.count
    end

    def present_employer_names?
      employed_monthly_employer&.all?(&:present?)
    end

    def payment_frequencies
      return true if job_and_frequency_counts_match? && present_frequencies?
      errors.add(
        :incomes_missing,
        "Make sure all jobs have a payment frequency",
      )
    end

    def job_and_frequency_counts_match?
      employed_number_of_jobs == employed_payment_frequency&.count
    end

    def present_frequencies?
      employed_payment_frequency&.all?(&:present?)
    end

    def unemployment_income_provided
      return true if unemployment_income.present?
      errors.add(:incomes_missing, "Make sure to provide unemployment income")
    end

    def self_employment_income
      return true if self_employed_monthly_income.present?
      errors.add(:incomes_missing, "Make sure to provide unemployment income")
    end
  end
end
