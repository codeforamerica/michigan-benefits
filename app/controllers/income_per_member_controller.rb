# frozen_string_literal: true

class IncomePerMemberController < ManyMemberStepsController
  private

  def skip?
    current_app.
      household_members.
      none? { |member| member.employed? || member.self_employed? }
  end

  def household_member_attrs
    %i[
      employer_name
      hours_per_week
      income_consistent
      monthly_expenses
      monthly_pay
      pay_interval
      pay_quantity
      profession
    ]
  end
end
