module ExpensesDetails
  extend ActiveSupport::Concern

  module ClassMethods
    def skip?(application)
      application.single_member_household? ||
        application.expenses.where(expense_type: expense_type).none?
    end
  end

  private

  delegate :expense_type, to: :class

  def form_class
    ExpensesDetailsForm
  end

  def existing_attributes
    HashWithIndifferentAccess.new(
      amount: expense.amount,
      member_ids: expense.members.map(&:id),
    )
  end

  def assign_attributes_to_form
    @form = form_class.new(form_params.merge(valid_members: current_application.members))
  end

  def update_models
    expense.update(params_for(:expense))
  end

  def expense
    current_application.expenses.find_by(expense_type: expense_type)
  end
end
