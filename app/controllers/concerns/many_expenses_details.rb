module ManyExpensesDetails
  extend ActiveSupport::Concern

  module ClassMethods
    def skip_rule_sets(application)
      [
        SkipRules.single_member_only(application),
      ]
    end

    def custom_skip_rule_set(application)
      application.expenses.public_send(expenses_scope).none?
    end
  end

  def edit
    @form = form_class.new(expenses: expenses)
  end

  private

  delegate :expenses_scope, to: :class

  def form_class
    ManyExpensesDetailsForm
  end

  def assign_attributes_to_form
    @form = form_class.new(expenses: expenses)
    @form.expenses.each do |expense|
      expense_params = form_params.dig(:expenses, expense.to_param)
      if expense_params.present?
        expense.assign_attributes(expense_params)
        expense.members = [current_application.primary_member]
      end
    end
  end

  def form_params
    params.require(:form).permit(expenses: [:amount])
  end

  def update_models
    ActiveRecord::Base.transaction do
      @form.expenses.compact.each(&:save!)
    end
  end

  def expenses
    current_application.expenses.public_send(expenses_scope)
  end
end
