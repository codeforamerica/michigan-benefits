class IncomeSourcesDetailsForm < Form
  set_member_attributes(:id, :additional_incomes)

  set_additional_income_attributes(:amount)

  validates :amount, numericality: {
    allow_nil: true,
    message: "Please include a dollar amount.",
  }

  validate :current_member_id_valid

  def valid_members=(members)
    @valid_members = members
  end

  def current_member_id_valid
    return true if @valid_members.map { |m| m.id.to_s }.include?(id)
    errors.add(:id, "Can't update that household member.")
    false
  end
end
