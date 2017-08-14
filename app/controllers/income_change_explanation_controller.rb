# frozen_string_literal: true

class IncomeChangeExplanationController < StandardStepsController
  private

  def skip?
    !current_snap_application.income_change?
  end
end
