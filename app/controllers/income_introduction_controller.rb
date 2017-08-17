# frozen_string_literal: true

class IncomeIntroductionController < StepsController
  def update
    redirect_to(next_path)
  end
end
