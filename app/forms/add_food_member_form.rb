class AddFoodMemberForm < Form
  include BirthdayValidations

  set_member_attributes(
    :first_name,
    :last_name,
    :birthday_year,
    :birthday_month,
    :birthday_day,
    :sex,
    :relationship,
  )

  validates :first_name,
            presence: { message: "Make sure to provide a first name" }

  validates :last_name,
            presence: { message: "Make sure to provide a last name" }

  validate :birthday_must_be_valid_date
end
