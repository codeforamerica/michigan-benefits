# frozen_string_literal: true

class IncomeChangeExplanationController < SnapStepsController
  private

  def skip?
    !current_application.income_change?
  end
end
