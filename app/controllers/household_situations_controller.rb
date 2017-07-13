# frozen_string_literal: true

class HouseholdSituationsController < SimpleStepController
  def edit
    step
  end

  def update
    step.household_members.each do |household_member|
      attrs = params
              .dig(:step, :household_members, household_member.to_param)
              &.permit(
                %i[is_citizen is_disabled is_new_mom in_college is_living_elsewhere]
              )

      household_member.assign_attributes(attrs) if attrs.present?
    end

    ActiveRecord::Base.transaction do
      step.household_members.each(&:save!)
    end

    redirect_to next_path
  end

  private

  def step
    @step ||= step_class.new(
      current_app
        .attributes
        .slice(*step_attrs)
        .merge(household_members: current_app.household_members)
    )
  end

  def skip?
    current_app.everyone_a_citizen &&
      !current_app.anyone_disabled &&
      !current_app.any_new_moms &&
      !current_app.anyone_in_college &&
      !current_app.anyone_living_elsewhere
  end
end
