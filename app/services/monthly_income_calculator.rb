class MonthlyIncomeCalculator
  AVERAGE_WEEKS_PER_MONTH = 4.33
  MONTHS_PER_YEAR = 12

  def initialize(pay_quantity: nil, pay_interval: nil, hours_per_week: nil)
    @pay_quantity = pay_quantity
    @pay_interval = pay_interval
    @hours_per_week = hours_per_week
  end

  def run
    if pay_quantity.nil? || pay_interval.nil?
      nil
    else
      calculate_based_on_pay_interval
    end
  end

  private

  attr_reader :hours_per_week, :pay_quantity, :pay_interval

  def calculate_based_on_pay_interval
    if pay_interval == "Hourly"
      return if hours_per_week.nil?
      hours_per_week * pay_quantity * AVERAGE_WEEKS_PER_MONTH
    elsif ["Every Two Weeks", "Twice a Month"].include?(pay_interval)
      pay_quantity * (AVERAGE_WEEKS_PER_MONTH / 2)
    elsif pay_interval == "Weekly"
      pay_quantity * AVERAGE_WEEKS_PER_MONTH
    elsif pay_interval == "Monthly"
      pay_quantity
    else #  pay_interval == "Yearly"
      pay_quantity.to_f / MONTHS_PER_YEAR
    end.round(2)
  end
end
