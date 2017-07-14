# frozen_string_literal: true

class IncomeChangeExplanationController < StandardSimpleStepController
  private

  def skip?
    !current_app.income_change?
  end
end
