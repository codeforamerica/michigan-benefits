class IncomeDetailsPerMemberController < ManyMemberStepsController
  private

  def skip?
    current_application.members.all?(&:not_employed?)
  end

  def member_attrs
    %i[
      employed_employer_name
      employed_hours_per_week
      employed_pay_interval
      employed_pay_quantity
      self_employed_monthly_expenses
      self_employed_monthly_income
      self_employed_profession
    ]
  end
end
