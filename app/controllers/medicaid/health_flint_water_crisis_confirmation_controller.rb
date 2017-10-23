# frozen_string_literal: true

module Medicaid
  class HealthFlintWaterCrisisConfirmationController < MedicaidStepsController
    private

    def skip?
      not_affected_by_flint_water_crisis?
    end

    def not_affected_by_flint_water_crisis?
      !current_application.flint_water_crisis?
    end
  end
end
