class Employment < ApplicationRecord
  belongs_to :application_member, polymorphic: true, counter_cache: true

  PAYCHECK_INTERVALS = {
    week: "Weekly",
    two_weeks: "Every two weeks",
    twice_a_month: "Twice a month",
    month: "Monthly",
    year: "Yearly",
  }.freeze

  # From https://stackoverflow.com/questions/29823884/rails-currency-validation#comment47774572_29824032
  DOLLAR_REGEX = /\A\$?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$\z/

  enum hourly_or_salary: { unfilled: 0, hourly: 1, salaried: 2 }

  validates :hours_per_week, numericality: {
    allow_nil: true,
    message: "Must be a number",
  }

  validates :pay_quantity, format: {
    with: DOLLAR_REGEX,
    allow_blank: true,
    message: "Make sure to enter a number",
  }

  def paycheck_interval_label
    PAYCHECK_INTERVALS[payment_frequency.to_sym]
  end

  def pay_quantity_hourly
    pay_quantity if hourly?
  end

  def pay_quantity_salary
    pay_quantity if salaried?
  end
end
