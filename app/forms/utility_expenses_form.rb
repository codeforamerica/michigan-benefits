class UtilityExpensesForm < Form
  set_attributes_for :application, *Expense::UTILITY_EXPENSES.keys
end
