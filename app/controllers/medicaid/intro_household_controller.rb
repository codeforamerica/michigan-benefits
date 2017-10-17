# frozen_string_literal: true

module Medicaid
  class IntroHouseholdController < MedicaidStepsController
    def edit
      @step = step_class.new(
        first_name: current_application.first_name,
        last_name: current_application.last_name,
      )
    end
  end
end
