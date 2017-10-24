# frozen_string_literal: true

module Medicaid
  class IncomeJobController < MedicaidStepsController
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
      { employment_status: employed_params }
    end

    def employed_params
      if step_params[:anyone_employed] == "true"
        "employed"
      end
    end
  end
end
