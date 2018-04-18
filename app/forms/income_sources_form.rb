class IncomeSourcesForm < Form
  set_member_attributes(:id, *Income::INCOME_SOURCES.keys)
end
