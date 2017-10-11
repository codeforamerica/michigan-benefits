# frozen_string_literal: true

class HouseholdMembersOverviewController < StandardStepsController
  include SnapFlow

  def edit
    @step = step_class.new(
      first_name: current_application.primary_member.first_name,
      non_applicant_members: current_application.non_applicant_members,
    )
  end
end
