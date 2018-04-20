module SingleExpense
  extend ActiveSupport::Concern

  def update_models
    if form_params[expense_type] == "true"
      expense_collection.find_or_create_by(expense_type: expense_type.to_s)
    else
      expense_collection.where(expense_type: expense_type.to_s).destroy_all
    end
  end
end
