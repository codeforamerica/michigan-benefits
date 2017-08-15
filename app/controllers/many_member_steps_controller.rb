# frozen_string_literal: true

class ManyMemberStepsController < StepsController
  def edit
    step
  end

  def update
    assign_household_member_attributes

    if step.valid?
      ActiveRecord::Base.transaction { step.members.each(&:save!) }
      redirect_to next_path
    else
      render :edit
    end
  end

  private

  def assign_household_member_attributes
    step.members.each do |member|
      attrs = params.dig(:step, :members, member.to_param)

      if attrs.present?
        member.assign_attributes(attrs.permit(member_attrs))
      end
    end
  end

  def step
    @step ||= step_class.new(
      current_snap_application.
        attributes.
        slice(*step_attrs).
        merge(members: current_snap_application.members),
    )
  end

  def member_attrs
    raise NotImplementedError
  end
end
