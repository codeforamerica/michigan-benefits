class OngoingMedicalExpensesForm < Form
  set_application_attributes(*Expense::MEDICAL_EXPENSES.keys)
end
