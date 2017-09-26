# frozen_string_literal: true

require_relative "./concerns/social_security_number.rb"

class HouseholdAddMember < Step
  include MultiparameterAttributeAssignment
  extend AutoStripAttributes
  include SocialSecurityNumber

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

  validates :relationship, inclusion: {
    in: %w(Spouse Parent Child Sibling Roommate Other),
    allow_blank: true,
  }

  # https://github.com/rails/rails/pull/8189#issuecomment-10329403
  def class_for_attribute(attr)
    return Date if attr == "birthday"
  end
end
