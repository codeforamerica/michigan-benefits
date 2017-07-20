# frozen_string_literal: true

class IncomeFluctuationController < ManyMemberStepsController
  private

  def skip?
    current_app.household_members.with_inconsistent_income.empty?
  end

  def household_member_attrs
    %i[
      expected_income_this_year
      expected_income_next_year
    ]
  end
end
