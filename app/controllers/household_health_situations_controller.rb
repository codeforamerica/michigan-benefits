# frozen_string_literal: true

class HouseholdHealthSituationsController < ManyMemberSimpleStepController
  private

  def household_member_attrs
    %i[medical_help insurance_lost_last_3_months]
  end

  def skip?
    !current_app.any_medical_bill_help_last_3_months &&
      !current_app.any_lost_insurance_last_3_months
  end
end
