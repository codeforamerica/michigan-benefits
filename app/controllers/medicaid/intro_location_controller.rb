# frozen_string_literal: true

module Medicaid
  class IntroLocationController < StandardStepsController
    include MedicaidFlow

    private

    def ensure_application_present
      true
    end
  end
end
