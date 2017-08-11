# frozen_string_literal: true

class IntroduceYourself < Step
  include MultiparameterAttributeAssignment

  step_attributes(
    :birthday,
    :first_name,
    :last_name,
  )

  validates :first_name,
    presence: { message: "Make sure to provide a first name" }

  validates :last_name,
    presence: { message: "Make sure to provide a last name" }

  validates :birthday,
    presence: { message: "Make sure to provide a birthday" }

  # https://github.com/rails/rails/pull/8189#issuecomment-10329403
  def class_for_attribute(attr)
    return Date if attr == "birthday"
  end
end
