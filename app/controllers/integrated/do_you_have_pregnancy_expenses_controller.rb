module Integrated
  class DoYouHavePregnancyExpensesController < FormsController
    def self.skip?(application)
      !application.single_member_household?
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
