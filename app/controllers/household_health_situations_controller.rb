# frozen_string_literal: true

class HouseholdHealthSituationsController < SimpleStepController
  def edit
    step
  end

  def update
    step.household_members.each do |household_member|
      attrs = params
              .dig(:step, :household_members, household_member.to_param)
              &.permit(%i[medical_help insurance_lost_last_3_months])

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
    !current_app.any_medical_bill_help_last_3_months &&
      !current_app.any_lost_insurance_last_3_months
  end
end
