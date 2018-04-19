class Expense < ApplicationRecord
  belongs_to :common_application

  scope :utilities, -> {
    where(expense_type: UTILITY_EXPENSES.keys)
  }

  UTILITY_EXPENSES = {
    phone: "Phone (including cell phones)",
    heat: "Heat",
    air_conditioning: "Air conditioning",
    electricity: "Electricity",
    water_sewer: "Water/Sewer",
    trash: "Trash",
    cooking_fuel: "Cooking Fuel",
  }.freeze

  def self.all_expense_types
    UTILITY_EXPENSES.keys
  end

  validates :expense_type, inclusion: { in: all_expense_types.map(&:to_s),
    message: "%{value} is not a valid expense type" }

  def display_name
    UTILITY_EXPENSES[expense_type.to_sym]
  end
end
