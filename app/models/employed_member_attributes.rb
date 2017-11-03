class EmployedMemberAttributes
  def initialize(member:, position:)
    @member = member
    @position = position
  end

  def to_h
    {
      "#{position}_employed_full_name" => member.display_name,
      "#{position}_employed_employer_name" => member.employed_employer_name,
      "#{position}_employed_hours_per_week" => member.employed_hours_per_week,
      "#{position}_employed_hours_interval" =>
        boolean_to_checkbox(member.employed_hours_per_week.present?),
      "#{position}_employed_pay_quantity" => member.employed_pay_quantity,
      "#{position}_employed_pay_interval_hourly" =>
        boolean_to_checkbox(member.employed_pay_interval == "Hourly"),
      "#{position}_employed_pay_interval_yearly" =>
        boolean_to_checkbox(member.employed_pay_interval == "Yearly"),
      "#{position}_employed_pay_interval_other" =>
        boolean_to_checkbox(other_pay_interval?),
      "#{position}_employed_pay_interval_other_detail" =>
        other_pay_interval_detail,
    }.symbolize_keys
  end

  private

  attr_reader :member, :position

  def other_pay_interval?
    member.employed_pay_interval != "Hourly" &&
      member.employed_pay_interval != "Yearly"
  end

  def other_pay_interval_detail
    if other_pay_interval?
      member.employed_pay_interval
    end
  end

  def boolean_to_checkbox(statement)
    if statement == true
      "Yes"
    end
  end
end
