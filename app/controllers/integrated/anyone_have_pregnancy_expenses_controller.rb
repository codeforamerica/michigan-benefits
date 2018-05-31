module Integrated
  class AnyoneHavePregnancyExpensesController < FormsController
    def self.skip_rule_sets(application)
      [SkipRules.multi_member_only(application)]
    end

    def update_models
      if params_for(:navigator)[:anyone_pregnancy_expenses] == "false"
        current_application.members.update_all(pregnancy_expenses: "no")
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
