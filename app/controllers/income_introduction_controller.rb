# frozen_string_literal: true

class IncomeIntroductionController < SnapStepsController
  def edit; end

  def update
    redirect_to(next_path)
  end
end
