class AddHouseholdMemberForm < Form
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

  def birthday_must_be_valid_date
    all_present = %i[birthday_year birthday_month birthday_day].all? { |att| send(att).present? }
    if all_present
      begin
        DateTime.new(birthday_year.to_i, birthday_month.to_i, birthday_day.to_i)
      rescue ArgumentError
        errors.add(:birthday, "Make sure to provide a real birth date")
      end
    end
  end
end
