class UtilityExpensesForm < Form
  set_application_attributes(*Expense.all_expense_types)
end
