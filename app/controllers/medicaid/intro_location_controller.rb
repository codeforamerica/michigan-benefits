# frozen_string_literal: true

module Medicaid
  class IntroLocationController < StandardStepsController
    private

    def ensure_application_present
      true
    end

    def existing_attributes
      {}
    end

    def step_class
      Medicaid::IntroLocation
    end
  end
end
