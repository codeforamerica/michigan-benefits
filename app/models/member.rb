class Member < ApplicationRecord
  include SocialSecurityNumber

  PAYMENT_INTERVALS = [
    "Hourly",
    "Weekly",
    "Every Two Weeks",
    "Twice a Month",
    "Monthly",
    "Yearly",
    "Other",
  ].freeze

  EMPLOYMENT_STATUSES = %w[
    employed
    self_employed
    not_employed
  ].freeze

  SEXES = %w[
    male
    female
  ].freeze

  MARITAL_STATUSES = [
    "Married",
    "Never married",
    "Divorced",
    "Widowed",
    "Separated",
  ].freeze

  TAX_RELATIONSHIPS = %w[
    Single
    Joint
    Dependent
  ].freeze

  OTHER_INCOME_TYPES = %w[
    alimony
    other
    pension
    retirement
    social_security
    unemployment
  ].freeze

  belongs_to :benefit_application, polymorphic: true, counter_cache: true
  has_one :spouse, class_name: "Member", foreign_key: "spouse_id"
  has_many :employments, dependent: :destroy

  validates :employed_pay_interval,
    inclusion: { in: PAYMENT_INTERVALS },
    allow_nil: true

  validates :insurance_type,
    inclusion: { in: Medicaid::InsuranceCurrentType::INSURANCE_TYPES.keys },
    allow_nil: true

  validates :employment_status,
    inclusion: { in: EMPLOYMENT_STATUSES },
    allow_nil: true

  validates :sex,
    inclusion: { in: SEXES },
    allow_nil: true

  validates :tax_relationship,
    inclusion: { in: TAX_RELATIONSHIPS },
    allow_nil: true

  validate :other_income_types_inclusion

  attribute :ssn
  attr_encrypted(
    :ssn,
    key: Rails.application.secrets.secret_key_for_ssn_encryption,
  )

  def other_income_types_inclusion
    if (other_income_types - OTHER_INCOME_TYPES).any?
      errors.add(:other_income_types, "Not a valid income type")
    end
  end

  def self.insured
    where(insured: true).
      where(requesting_health_insurance: true).
      order(created_at: :asc)
  end

  def self.married
    where(married: true).order(created_at: :asc)
  end

  def self.other_income
    where(other_income: true).order(created_at: :asc)
  end

  def self.after(member)
    where("created_at > ?", member.created_at)
  end

  def spouse_options
    benefit_application.members.married -
      [self] +
      [OtherSpouse.new]
  end

  def display_name
    "#{first_name.upcase_first} #{last_name.upcase_first}"
  end

  def self.filing_taxes
    where "members.tax_relationship in ('Single', 'Joint')"
  end

  def self.dependents
    where "members.tax_relationship = 'Dependent'"
  end

  def self.no_tax_relationship
    where("coalesce(members.tax_relationship, '') = ''")
  end

  def self.receiving_income
    where(
      <<~SQL
        members.employed = true OR
          members.self_employed = true OR
          'unemployment' = ANY (members.other_income_types)
      SQL
    )
  end

  def self.with_expenses
    where(
      <<~SQL
        members.self_employed = true OR
          members.pay_student_loan_interest = true OR
          members.pay_child_support_alimony_arrears = true
      SQL
    )
  end

  def not_receiving_income?
    !receiving_income?
  end

  def primary_member?
    benefit_application.primary_member.id == id
  end

  def monthly_income
    if employment_status == "self_employed"
      self_employed_monthly_income
    elsif employment_status == "employed"
      employed_monthly_income
    else
      0
    end
  end

  def not_employed?
    employment_status == "not_employed"
  end

  def receives_unemployment_income?
    other_income_types.include? "unemployment"
  end

  def female?
    sex == "female"
  end

  def male?
    sex == "male"
  end

  def mi_bridges_formatted_name
    "#{first_name.first(10)} (#{age})"
  end

  def age
    today = Date.today
    age = today.year - birthday.year
    before_birthday = today.strftime("%m%d") < birthday.strftime("%m%d")
    age - (before_birthday ? 1 : 0)
  end

  private

  def receiving_income?
    employed? ||
      self_employed? ||
      receives_unemployment_income?
  end

  def employed_monthly_income
    MonthlyIncomeCalculator.new(
      pay_interval: employed_pay_interval,
      pay_quantity: employed_pay_quantity,
      hours_per_week: employed_hours_per_week,
    ).run
  end
end
