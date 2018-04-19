class UtilityExpensesForm < Form
  set_application_attributes(*Expense::UTILITY_EXPENSES.keys)
end
