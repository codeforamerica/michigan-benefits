# frozen_string_literal: true

class IncomeCurrentlyEmployedController < ManyMemberStepsController
  private

  def household_member_attrs
    %i[employment_status]
  end
end
