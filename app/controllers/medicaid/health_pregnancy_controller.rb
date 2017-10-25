# frozen_string_literal: true

module Medicaid
  class HealthPregnancyController < MedicaidStepsController
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

    def skip?
      all_males?
    end

    def all_males?
      current_application.members.all? do |member|
        member.sex == "male"
      end
    end

    def member_attrs
      { new_mom: step_params[:anyone_new_mom] }
    end
  end
end
