module Medicaid
  class ManyMemberStepsController < MedicaidStepsController
    def edit
      step
    end

    def update
      assign_household_member_attributes

      if step.valid?
        update_application
        redirect_to(next_path)
      else
        render :edit
      end
    end

    private

    def update_application
      ActiveRecord::Base.transaction { step.members.each(&:save!) }
    end

    def assign_household_member_attributes
      step.members.each do |member|
        attrs = params.dig(:step, :members, member.to_param)
        member.assign_attributes(attrs.permit(member_attrs))
      end
    end

    def step
      @step ||= step_class.new(members: members)
    end

    def members
      current_application.members
    end

    def member_attrs
      raise NotImplementedError
    end
  end
end
