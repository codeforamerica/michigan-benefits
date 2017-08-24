# frozen_string_literal: true

class IntroductionCompleteController < StepsController
  def update
    redirect_to(next_path)
  end
end
