class HouseholdMoreInfoPerMemberController < ManyMemberStepsController
  private

  def member_attrs
    %i[citizen disabled new_mom in_college living_elsewhere]
  end

  def skip?
    no_additional_info_needed?
  end

  def no_additional_info_needed?
    current_application.everyone_a_citizen? &&
      !current_application.anyone_disabled? &&
      !current_application.anyone_new_mom? &&
      !current_application.anyone_in_college? &&
      !current_application.anyone_living_elsewhere?
  end
end
