# frozen_string_literal: true

class ExpensesIntroductionController < StepsController
  def update
    redirect_to(next_path)
  end
end
