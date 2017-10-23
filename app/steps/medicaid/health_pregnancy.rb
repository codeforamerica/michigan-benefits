# frozen_string_literal: true

module Medicaid
  class HealthPregnancy < Step
    step_attributes(
      :new_mom,
      :members,
    )

    def female_members
      members.select(&:female?)
    end
  end
end
