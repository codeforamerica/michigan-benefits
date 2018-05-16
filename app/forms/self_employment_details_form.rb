class SelfEmploymentDetailsForm < Form
  set_attributes_for :member,
                     :id, :self_employment_description, :self_employment_income, :self_employment_expense

  validates :self_employment_income, numericality: {
    allow_nil: true,
    message: "Must be a number without decimals",
  }

  validates :self_employment_expense, numericality: {
    allow_nil: true,
    message: "Must be a number without decimals",
  }
end
