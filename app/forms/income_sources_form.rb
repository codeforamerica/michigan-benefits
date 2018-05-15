class IncomeSourcesForm < Form
  set_member_attributes(:id, *AdditionalIncome.all_income_types)
end
