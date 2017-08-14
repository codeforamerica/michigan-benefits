# frozen_string_literal: true

class HouseholdAddMember < Step
  include MultiparameterAttributeAssignment

  step_attributes(
    :birthday,
    :buy_food_with,
    :first_name,
    :last_name,
    :relationship,
    :requesting_food_assistance,
    :sex,
    :ssn,
  )

  validates :first_name,
    presence: { message: "Make sure to provide their first name" }

  validates :last_name,
    presence: { message: "Make sure to provide their last name" }

  validates :requesting_food_assistance, inclusion: {
    in: %w(true false),
    message: "Make sure to answer this question",
  }

  # https://github.com/rails/rails/pull/8189#issuecomment-10329403
  def class_for_attribute(attr)
    return Date if attr == "birthday"
  end
end
