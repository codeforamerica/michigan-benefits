class AddTaxMemberForm < AddMemberForm
  set_member_attributes(
    :first_name,
    :last_name,
    :birthday_year,
    :birthday_month,
    :birthday_day,
    :sex,
    :relationship,
    :tax_relationship,
  )
  validates :tax_relationship, presence: { message: "Make sure to specify tax filing status." }
end
