module Medicaid
  class AmountsIncome < MemberStep
    step_attributes(
      { employed_monthly_income: [] },
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

    def valid?
      if jobs_and_income_dont_match?
        errors.add(:incomes_missing, "Make sure all jobs have an income amount")
        false
      elsif unemployment_income_is_not_provided?
        errors.add(:incomes_missing, "Make sure to provide unemployment income")
        false
      elsif self_employment_income_not_provided?
        errors.add(
          :incomes_missing,
          "Make sure to provide self-employment income",
        )
        false
      else
        true
      end
    end

    private

    def jobs_and_income_dont_match?
      employed_number_of_jobs != employed_monthly_income&.count
    end

    def unemployment_income_is_not_provided?
      receives_unemployment_income? && unemployment_income.blank?
    end

    def self_employment_income_not_provided?
      self_employed? && self_employed_monthly_income.blank?
    end
  end
end
