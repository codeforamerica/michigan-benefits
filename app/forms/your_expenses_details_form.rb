class YourExpensesDetailsForm < Form
  set_attributes_for :application, :expenses

  set_attributes_for :expense, :amount

  validate :expenses_valid?

  def expenses_valid?
    if expenses.map(&:valid?).all?
      true
    else
      errors.add(:expenses)
      false
    end
  end
end
