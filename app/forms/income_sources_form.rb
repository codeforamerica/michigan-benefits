class IncomeSourcesForm < Form
  set_member_attributes(:id, *Income.all_income_types)
end
