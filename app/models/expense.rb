class Expense < ApplicationRecord
  HOUSING_EXPENSES = {
    rent: "Rent",
    mortgage: "Mortgage",
    mobile_home_lot_rent: "Mobile home lot rent",
    property_tax: "Property taxes",
    homeowners_insurance: "Homeowners or renters insurance",
    land_contract: "Land contract",
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

  DEPENDENT_CARE_EXPENSES = {
    childcare: "Childcare",
    disability_care: "Dependent Care",
  }.freeze

  COURT_ORDERED_EXPENSES = {
    child_support: "Child Support",
    alimony: "Alimony",
  }.freeze

  OTHER_PERMITTED_EXPENSES = {
    student_loan_interest: "Student Loan Interest",
  }.freeze

  belongs_to :common_application

  has_and_belongs_to_many :members,
    -> { order(created_at: :asc) },
    class_name: "HouseholdMember",
    foreign_key: "expense_id"

  scope :housing, -> {
    where(expense_type: HOUSING_EXPENSES.keys)
  }

  scope :medical, -> {
    where(expense_type: MEDICAL_EXPENSES.keys)
  }

  scope :utilities, -> {
    where(expense_type: UTILITY_EXPENSES.keys)
  }

  scope :dependent_care, -> {
    where(expense_type: DEPENDENT_CARE_EXPENSES.keys)
  }

  scope :court_ordered, -> {
    where(expense_type: COURT_ORDERED_EXPENSES.keys)
  }

  scope :student_loan_interest, -> {
    where(expense_type: :student_loan_interest)
  }

  scope :court_ordered_or_other, -> {
    where(expense_type: COURT_ORDERED_EXPENSES.keys + OTHER_PERMITTED_EXPENSES.keys)
  }

  def self.all_expenses
    HOUSING_EXPENSES.merge(
      **MEDICAL_EXPENSES,
      **UTILITY_EXPENSES,
      **DEPENDENT_CARE_EXPENSES,
      **COURT_ORDERED_EXPENSES,
      **OTHER_PERMITTED_EXPENSES,
    )
  end

  def self.all_expense_types
    all_expenses.keys
  end

  validates :expense_type, inclusion: { in: all_expense_types.map(&:to_s),
                                        message: "%<value>s is not a valid expense type" }
  validates :amount, numericality: {
    allow_nil: true,
    message: "Make sure to enter a number",
  }

  def display_name
    all_expenses[expense_type.to_sym]
  end

  delegate :all_expenses, to: :class
end
