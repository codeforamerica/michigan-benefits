# frozen_string_literal: true

class HouseholdMoreInfo < Step
  step_attributes(
    :everyone_a_citizen,
    :anyone_disabled,
    :anyone_new_mom,
    :anyone_in_college,
    :anyone_living_elsewhere,
  )

  validates :everyone_a_citizen, inclusion: {
    in: %w(true false),
    message: "Make sure to answer this question",
  }

  validates :anyone_disabled, inclusion: {
    in: %w(true false),
    message: "Make sure to answer this question",
  }

  validates :anyone_new_mom, inclusion: {
    in: %w(true false),
    message: "Make sure to answer this question",
  }

  validates :anyone_in_college, inclusion: {
    in: %w(true false),
    message: "Make sure to answer this question",
  }

  validates :anyone_living_elsewhere, inclusion: {
    in: %w(true false),
    message: "Make sure to answer this question",
  }
end
