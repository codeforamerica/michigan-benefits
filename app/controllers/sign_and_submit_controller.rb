# frozen_string_literal: true

class SignAndSubmitController < SnapStepsController
  private

  def step_params
    super.merge(signed_at: Time.current)
  end
end
