module Integrated
  class DoYouHavePregnancyExpensesController < FormsController
    def self.skip_rule_sets(application)
      [SkipRules.single_member_only(application)]
    end

    def update_models
      member_params = params_for(:member)
      current_application.primary_member.update!(member_params)

      if member_params[:pregnancy_expenses] == "no"
        current_application.navigator.update!(anyone_pregnancy_expenses: false)
      end
    end
  end
end
