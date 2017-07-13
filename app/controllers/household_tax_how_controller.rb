# frozen_string_literal: true

class HouseholdTaxHowController < ManyMemberSimpleStepController
  private

  def household_member_attrs
    %i[filing_status]
  end

  def skip?
    !current_app.household_tax
  end
end
