class Member < ApplicationRecord
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

  belongs_to :benefit_application, polymorphic: true

  validates :employed_pay_interval,
    inclusion: { in: PAYMENT_INTERVALS },
    allow_nil: true

  validates :employment_status,
    inclusion: { in: EMPLOYMENT_STATUSES },
    allow_nil: true

  validates :sex,
    inclusion: { in: SEXES },
    allow_nil: true

  attribute :ssn
  attr_encrypted(
    :ssn,
    key: Rails.application.secrets.secret_key_for_ssn_encryption,
  )

  def full_name
    "#{first_name} #{last_name}"
  end

  def primary_member?
    benefit_application.primary_member.id == id
  end

  def monthly_income
    if employment_status == "self_employed"
      self_employed_monthly_income
    elsif employed?
      employed_monthly_income
    else
      0
    end
  end

  def employed?
    employment_status == "employed"
  end

  def not_employed?
    employment_status == "not_employed"
  end

  def female?
    sex == "female"
  end

  def male?
    sex == "male"
  end

  def formatted_birthday
    birthday.strftime("%m/%d/%Y")
  end

  def mi_bridges_formatted_name
    "#{first_name.first(10)} (#{age})"
  end

  private

  def age
    today = Date.today
    age = today.year - birthday.year
    before_birthday = today.strftime("%m%d") < birthday.strftime("%m%d")
    age - (before_birthday ? 1 : 0)
  end

  def employed_monthly_income
    MonthlyIncomeCalculator.new(
      pay_interval: employed_pay_interval,
      pay_quantity: employed_pay_quantity,
      hours_per_week: employed_hours_per_week,
    ).run
  end
end
