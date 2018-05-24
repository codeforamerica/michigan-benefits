class ManyExpensesDetailsForm < Form
  attr_accessor :expenses

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
