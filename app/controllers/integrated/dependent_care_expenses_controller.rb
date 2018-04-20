module Integrated
  class DependentCareExpensesController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if form_params[:disability_care] == "true"
        current_application.expenses.dependent_care.find_or_create_by(expense_type: "disability_care")
      else
        current_application.expenses.dependent_care.where(expense_type: "disability_care").destroy_all
      end
    end
  end
end
