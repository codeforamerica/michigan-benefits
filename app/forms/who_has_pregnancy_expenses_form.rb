class WhoHasPregnancyExpensesForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :pregnancy_expenses

  validate :at_least_one_person

  def at_least_one_person
    return true if members.any?(&:pregnancy_expenses_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
