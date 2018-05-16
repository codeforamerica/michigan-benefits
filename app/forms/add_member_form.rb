class AddMemberForm < Form
  include BirthdayValidations

  set_attributes_for :member,
                     :first_name, :last_name, :birthday_year, :birthday_month, :birthday_day, :sex, :relationship

  validates :first_name,
    presence: { message: "Make sure to provide a first name" }

  validates :last_name,
    presence: { message: "Make sure to provide a last name" }

  validates :relationship,
    presence: { message: "Make sure to choose a relationship" }

  validate :birthday_must_be_valid_date
end
