module Integrated
  class ChildcareExpensesController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if form_params[:childcare] == "true"
        current_application.expenses.dependent_care.find_or_create_by(expense_type: "childcare")
      else
        current_application.expenses.dependent_care.where(expense_type: "childcare").destroy_all
      end
    end
  end
end
