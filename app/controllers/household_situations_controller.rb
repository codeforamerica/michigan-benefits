# frozen_string_literal: true

class HouseholdSituationsController < ManyMemberStepsController
  private

  def household_member_attrs
    %i[is_citizen is_disabled is_new_mom in_college is_living_elsewhere]
  end

  def skip?
    current_app.everyone_a_citizen &&
      !current_app.anyone_disabled &&
      !current_app.any_new_moms &&
      !current_app.anyone_in_college &&
      !current_app.anyone_living_elsewhere
  end
end
