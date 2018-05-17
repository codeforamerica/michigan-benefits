module Integrated
  class ChildcareExpensesDetailsController < FormsController
    def self.skip?(application)
      application.single_member_household? || application.expenses.where(expense_type: :childcare).none?
    end

    helper_method :members

    def members
      current_application.members
    end

    private

    def existing_attributes
      HashWithIndifferentAccess.new(
        amount: expense.amount,
        member_ids: expense.members.map(&:id),
      )
    end

    def assign_attributes_to_form
      @form = form_class.new(form_params.merge(valid_members: members))
    end

    def update_models
      expense.update(params_for(:expense))
    end

    def expense
      current_application.expenses.find_by(expense_type: :childcare)
    end
  end
end
