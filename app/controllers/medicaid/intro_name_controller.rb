# frozen_string_literal: true

module Medicaid
  class IntroNameController < MedicaidStepsController
    def update
      @step = step_class.new(step_params)

      if @step.valid?
        member.update!(step_params)
        redirect_to(next_path)
      else
        render :edit
      end
    end

    private

    def existing_attributes
      HashWithIndifferentAccess.new(member_attributes)
    end

    def member_attributes
      {
        first_name: member.first_name,
        last_name: member.last_name,
        sex: member.sex,
      }
    end

    def member
      current_application.members.first ||
        current_application.members.new
    end
  end
end
