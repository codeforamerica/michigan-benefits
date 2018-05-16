class IncomeSourcesDetailsForm < MemberPerPageForm
  set_attributes_for :member,
                     :id, :additional_incomes

  set_attributes_for :additional_income, :amount

  validates :amount, numericality: {
    allow_nil: true,
    message: "Please include a dollar amount.",
  }
end
