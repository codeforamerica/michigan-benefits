# frozen_string_literal: true

class HouseholdTaxHowController < ManyMemberStepsController
  private

  def household_member_attrs
    %i[filing_status]
  end

  def skip?
    !current_app.household_tax
  end
end
