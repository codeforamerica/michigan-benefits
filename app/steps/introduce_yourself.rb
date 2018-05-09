class IntroduceYourself < Step
  include MultiparameterAttributeAssignment

  step_attributes(
    :birthday,
    :first_name,
    :last_name,
    :office_page,
  )

  validates :first_name,
    presence: { message: "Make sure to provide a first name" }

  validates :last_name,
    presence: { message: "Make sure to provide a last name" }

  validates :birthday,
    presence: { message: "Make sure to provide a birthday" }

  validates(
    :office_page,
    allow_blank: true,
    inclusion: {
      in: %w(clio union),
      message: "Select a valid office location.",
    },
  )

  # https://github.com/rails/rails/pull/8189#issuecomment-10329403
  def class_for_attribute(attr)
    return Date if attr == "birthday"
  end
end
