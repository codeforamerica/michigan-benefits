# frozen_string_literal: true

class ManyMemberStepsController < StepsController
  def edit
    step
  end

  def update
    step.household_members.each do |household_member|
      attrs = params.dig(:step, :household_members, household_member.to_param)

      if attrs.present?
        household_member.assign_attributes(attrs.permit(household_member_attrs))
      end
    end

    if step.valid?
      ActiveRecord::Base.transaction { step.household_members.each(&:save!) }
      redirect_to next_path
    else
      render :edit
    end
  end

  private

  def household_member_attrs
    raise NotImplementedError
  end

  def step
    @step ||= step_class.new(
      current_app
        .attributes
        .slice(*step_attrs)
        .merge(household_members: current_app.household_members)
    )
  end
end
