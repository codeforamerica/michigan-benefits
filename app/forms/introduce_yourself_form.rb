class IntroduceYourselfForm < AddMemberForm
  set_attributes_for :application, :previously_received_assistance

  set_attributes_for :member,
                     :first_name, :last_name, :birthday_year, :birthday_month, :birthday_day,
                     :sex, :relationship

  validates :sex, inclusion: {
    in: %w(male female),
    message: "Make sure to answer this question",
  }

  validate :birthday_must_be_present
end
