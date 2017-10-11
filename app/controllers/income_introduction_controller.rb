# frozen_string_literal: true

class IncomeIntroductionController < StepsController
  include SnapFlow

  def update
    redirect_to(next_path)
  end
end
