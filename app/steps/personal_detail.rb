# frozen_string_literal: true

class PersonalDetail < Step
  include MultiparameterAttributeAssignment

  step_attributes :name, :birthday

  validates :name,
    presence: { message: "Make sure to provide a full name" }

  validates :birthday,
    presence: { message: "Make sure to provide a birthday" }

  # https://github.com/rails/rails/pull/8189#issuecomment-10329403
  def class_for_attribute(attr)
    return Date if attr == "birthday"
  end
end
