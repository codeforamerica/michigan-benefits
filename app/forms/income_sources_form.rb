class IncomeSourcesForm < Form
  set_attributes_for :member,
                     :id, *AdditionalIncome.all_income_types
end
