class OngoingMedicalExpensesForm < Form
  set_attributes_for :application, *Expense::MEDICAL_EXPENSES.keys
end
