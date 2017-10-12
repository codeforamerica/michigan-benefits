# frozen_string_literal: true

module Medicaid
  class IntroName < Step
    step_attributes(
      :first_name,
      :last_name,
      :gender,
    )
  end
end
