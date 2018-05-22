module Integrated
  class YourExpensesDetailsController < FormsController
    def self.skip?(application)
      is_multi_member = !application.single_member_household?
      no_court_ordered_or_other_expenses = application.expenses.court_ordered_or_other.none?
      is_multi_member || no_court_ordered_or_other_expenses
    end

    def edit
      @form = form_class.new(expenses: expenses)
    end

    def assign_attributes_to_form
      @form = form_class.new(expenses: expenses)
      @form.expenses.map do |expense|
        expense_params = form_params.dig(:expenses, expense.to_param)
        if expense_params.present?
          expense.assign_attributes(expense_params.slice(*form_attrs))
        end
      end
    end

    def update_models
      ActiveRecord::Base.transaction do
        @form.expenses.compact.each(&:save!)
      end
    end

    private

    def expenses
      current_application.expenses.court_ordered_or_other
    end

    def form_params
      params.fetch(:form, {}).permit(*form_attrs, expenses: {})
    end
  end
end
