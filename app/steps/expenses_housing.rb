# frozen_string_literal: true

class ExpensesHousing < SimpleStep
  step_attributes \
    :rent_expense,
    :property_tax_expense,
    :insurance_expense,
    :utility_heat,
    :utility_cooling,
    :utility_electrity,
    :utility_water_sewer,
    :utility_trash,
    :utility_phone,
    :utility_other
end
