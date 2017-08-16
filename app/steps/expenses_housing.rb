# frozen_string_literal: true

class ExpensesHousing < Step
  step_attributes(
    :insurance_expense,
    :property_tax_expense,
    :rent_expense,
    :utility_cooling,
    :utility_electrity,
    :utility_heat,
    :utility_other,
    :utility_phone,
    :utility_trash,
    :utility_water_sewer,
  )
end
