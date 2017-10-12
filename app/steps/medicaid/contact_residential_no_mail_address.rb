# frozen_string_literal: true

module Medicaid
  class ContactResidentialNoMailAddress < Step
    step_attributes(
      :residential_street_address,
      :residential_city,
      :residential_zip,
    )
  end
end
