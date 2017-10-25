# frozen_string_literal: true

module Medicaid
  class IncomeSelfEmploymentController < MedicaidStepsController
    def update
      @step = step_class.new(step_params)

      if @step.valid?
        if single_member_household?
          current_application.primary_member.update!(member_attrs)
        end

        current_application.update!(step_params)
        redirect_to(next_path)
      else
        render :edit
      end
    end

    private

    def member_attrs
      { self_employed: step_params[:anyone_self_employed] }
    end
  end
end
