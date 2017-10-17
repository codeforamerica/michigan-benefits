# frozen_string_literal: true

module Medicaid
  class IntroHousehold < Step
    step_attributes(
      :first_name,
      :last_name,
    )
  end
end
