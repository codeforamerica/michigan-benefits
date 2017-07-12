class HouseholdMembersOverviewController < SimpleStepController
  def edit
    @step = step_class.new(
      first_name: current_app.applicant.first_name,
      non_applicant_members: current_app.non_applicant_members
    )
  end
end
