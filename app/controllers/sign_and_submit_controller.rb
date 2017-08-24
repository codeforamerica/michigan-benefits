# frozen_string_literal: true

class SignAndSubmitController < StandardStepsController
  private

  def step_params
    super.merge(signed_at: Time.current)
  end
end
