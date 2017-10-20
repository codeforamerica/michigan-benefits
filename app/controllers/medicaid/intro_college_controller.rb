# frozen_string_literal: true

module Medicaid
  class IntroCollegeController < MedicaidStepsController
    def update
      @step = step_class.new(step_params)

      if @step.valid?
        if current_application.members&.count == 1
          current_application.primary_member.update!(in_college: true)
        end

        current_application.update!(step_params)
        redirect_to(next_path)
      else
        render :edit
      end
    end
  end
end
