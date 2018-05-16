class AddTaxMemberForm < AddMemberForm
  set_attributes_for :member,
                     :first_name, :last_name, :birthday_year, :birthday_month, :birthday_day, :sex, :relationship,
                     :tax_relationship, :tax_relationship_spouse

  validates :tax_relationship,
            presence: { message: "Make sure to specify a tax filing status." },
            unless: :spouse?

  validates :tax_relationship_spouse,
            presence: { message: "Make sure to specify a tax filing status." },
            if: :spouse?

  def spouse?
    relationship == "spouse"
  end
end
