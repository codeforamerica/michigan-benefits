class HourlyIncomeCalculator
  AVERAGE_WEEKS_PER_MONTH = 4.33
  def initialize(pay_quantity: nil, pay_interval: nil, hours_per_week: nil)
    @pay_quantity = pay_quantity.to_f
    @pay_interval = pay_interval
    @hours_per_week = hours_per_week
  end

  def run
    if pay_interval == "Hourly"
      pay_quantity
    elsif ["Every Two Weeks", "Twice a Month"].include?(pay_interval)
      pay_quantity / (hours_per_week * 2)
    elsif pay_interval == "Weekly"
      pay_quantity / hours_per_week
    elsif pay_interval == "Monthly"
      pay_quantity / (hours_per_week * AVERAGE_WEEKS_PER_MONTH)
    else
      0
    end.round(2)
  end

  private

  attr_reader :hours_per_week, :pay_quantity, :pay_interval
end
