# frozen_string_literal: true

class IncomeChangeExplanationController < StandardStepsController
  private

  def skip?
    !current_app.income_change?
  end
end
