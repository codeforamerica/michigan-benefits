class IntroduceYourselfForm < AddMemberForm
  set_application_attributes(:previously_received_assistance)
  set_member_attributes(
    :first_name,
    :last_name,
    :birthday_year,
    :birthday_month,
    :birthday_day,
    :sex,
  )

  validates :sex, inclusion: {
    in: %w(male female),
    message: "Make sure to answer this question",
  }

  validate :birthday_must_be_present

  def skip_relationship_validation?
    true
  end
end
