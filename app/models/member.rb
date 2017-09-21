class Member < ApplicationRecord
  AVERAGE_WEEKS_PER_MONTH = 4.33
  MONTHS_PER_YEAR = 12
  belongs_to :snap_application

  attribute :ssn
  attr_encrypted(
    :ssn,
    key: Rails.application.secrets.secret_key_for_ssn_encryption,
  )

  def full_name
    "#{first_name} #{last_name}"
  end

  def primary_member?
    snap_application.primary_member.id == id
  end

  def monthly_income
    if self_employed?
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

  def self_employed?
    employment_status == "self_employed"
  end

  def not_employed?
    employment_status == "not_employed"
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
    return if employed_pay_quantity.nil?
    if employed_pay_interval == "Hourly"
      employed_hours_per_week * employed_pay_quantity * AVERAGE_WEEKS_PER_MONTH
    elsif employed_pay_interval == "Daily"
      employed_pay_quantity * (AVERAGE_WEEKS_PER_MONTH * 5)
    elsif employed_pay_interval == "Weekly"
      employed_pay_quantity * AVERAGE_WEEKS_PER_MONTH
    elsif employed_pay_interval == "Monthly"
      employed_pay_quantity
    else # "Year"
      employed_pay_quantity / MONTHS_PER_YEAR
    end
  end
end
