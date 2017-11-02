# frozen_string_literal: true

module Medicaid
  class SuccessController < MedicaidStepsController
    def step_class
      NullStep
    end

    def previous_path(*_args)
      nil
    end
  end
end
