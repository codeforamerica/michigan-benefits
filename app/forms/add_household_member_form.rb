class AddHouseholdMemberForm < Form
  include MultiparameterAttributeAssignment

  set_member_attributes(
    :first_name,
    :last_name,
    :birthday,
    :sex,
    :relationship,
  )

  validates :first_name,
    presence: { message: "Make sure to provide a first name" }

  validates :last_name,
    presence: { message: "Make sure to provide a last name" }

  # https://github.com/rails/rails/pull/8189#issuecomment-10329403
  def class_for_attribute(attr)
    return Date if attr == "birthday"
  end
end
