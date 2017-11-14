module Medicaid
  class AmountsOverviewController < MedicaidStepsController
    private

    def skip?
      current_application.no_one_with_income? &&
        current_application.no_expenses?
    end
  end
end
