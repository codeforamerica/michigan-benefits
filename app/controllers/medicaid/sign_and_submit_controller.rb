# frozen_string_literal: true

module Medicaid
  class SignAndSubmitController < MedicaidStepsController
    private

    def step_params
      super.merge(signed_at: Time.current)
    end
  end
end
