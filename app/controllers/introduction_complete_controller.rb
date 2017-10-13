# frozen_string_literal: true

class IntroductionCompleteController < SnapStepsController
  def update
    redirect_to(next_path)
  end
end
