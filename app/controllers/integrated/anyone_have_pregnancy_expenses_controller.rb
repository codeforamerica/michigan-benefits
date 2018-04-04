module Integrated
  class AnyoneHavePregnancyExpensesController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if navigator_params[:anyone_pregnancy_expenses] == "false"
        current_application.members.update_all(pregnancy_expenses: "no")
      end

      current_application.navigator.update!(navigator_params)
    end
  end
end
