class IntroduceYourselfForm < Form
  include BirthdayValidations

  set_application_attributes(:previously_received_assistance)

  set_member_attributes(
    :first_name,
    :last_name,
    :birthday_year,
    :birthday_month,
    :birthday_day,
    :sex,
  )

  validates :first_name,
    presence: { message: "Make sure to provide a first name" }

  validates :last_name,
    presence: { message: "Make sure to provide a last name" }

  validates :sex, inclusion: {
    in: %w(male female),
    message: "Make sure to answer this question",
  }

  validate :birthday_must_be_present
  validate :birthday_must_be_valid_date
end
