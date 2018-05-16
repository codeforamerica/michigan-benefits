class HousingExpensesForm < Form
  set_attributes_for :application, *Expense::HOUSING_EXPENSES.keys
end
