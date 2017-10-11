# frozen_string_literal: true

class IncomeChangeExplanationController < StandardStepsController
  include SnapFlow

  private

  def skip?
    !current_application.income_change?
  end
end
