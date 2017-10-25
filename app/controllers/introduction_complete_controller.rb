# frozen_string_literal: true

class IntroductionCompleteController < SnapStepsController
  def step_class
    NullStep
  end

  def update
    redirect_to(next_path)
  end
end
