module Medicaid
  class ManyMemberStepsController < MedicaidStepsController
    def edit
      step
    end

    def update
      assign_household_member_attributes

      if step.valid?
        ActiveRecord::Base.transaction { step.members.each(&:save!) }
        after_successful_update_hook
        redirect_to(next_path)
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
        current_application.
          attributes.
          slice(*step_attrs).
          merge(members: current_application.members),
      )
    end

    def member_attrs
      raise NotImplementedError
    end
  end
end
