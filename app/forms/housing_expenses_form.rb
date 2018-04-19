class HousingExpensesForm < Form
  set_application_attributes(*Expense::HOUSING_EXPENSES.keys)
end
