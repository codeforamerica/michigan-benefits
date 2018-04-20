class Expense < ApplicationRecord
  HOUSING_EXPENSES = {
    rent: "Rent",
    mortgage: "Mortgage",
    property_tax: "Property taxes",
    homeowners_insurance: "Homeowners or renters insurance",
    other_housing: "Other",
  }.freeze

  MEDICAL_EXPENSES = {
    health_insurance: "Health Insurance",
    copays: "Co-pays",
    prescriptions: "Prescriptions",
    transportation: "Transportation for medical care",
    dental: "Dental",
    in_home_care: "In-home care",
    hospital_bills: "Hospital bills",
    other_medical: "Other ongoing medical expenses",
  }.freeze

  UTILITY_EXPENSES = {
    phone: "Phone (including cell phones)",
    heat: "Heat",
    air_conditioning: "Air conditioning",
    electricity: "Electricity",
    water_sewer: "Water/Sewer",
    trash: "Trash",
    cooking_fuel: "Cooking Fuel",
  }.freeze

  belongs_to :common_application

  scope :housing, -> {
    where(expense_type: HOUSING_EXPENSES.keys)
  }

  scope :medical, -> {
    where(expense_type: MEDICAL_EXPENSES.keys)
  }

  scope :utilities, -> {
    where(expense_type: UTILITY_EXPENSES.keys)
  }

  def self.all_expenses
    HOUSING_EXPENSES.merge(
      **MEDICAL_EXPENSES,
      **UTILITY_EXPENSES,
    )
  end

  def self.all_expense_types
    all_expenses.keys
  end

  validates :expense_type, inclusion: { in: all_expense_types.map(&:to_s),
                                        message: "%<value>s is not a valid expense type" }

  def display_name
    all_expenses[expense_type.to_sym]
  end
end
