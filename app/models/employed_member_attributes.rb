# frozen_string_literal: true

class EmployedMemberAttributes
  def initialize(member:, position:)
    @member = member
    @position = position
  end

  def to_h
    {
      "#{position}_employed_full_name" => member.full_name,
      "#{position}_employed_employer_name" => member.employed_employer_name,
      "#{position}_employed_hours_per_week" => member.employed_hours_per_week,
      "#{position}_employed_pay_quantity" => member.employed_pay_quantity,
      "#{position}_employed_pay_interval_hourly" =>
        boolean_to_checkbox(member.employed_pay_interval == "Hour"),
      "#{position}_employed_pay_interval_yearly" =>
        boolean_to_checkbox(member.employed_pay_interval == "Year"),
      "#{position}_employed_pay_interval_other" =>
        boolean_to_checkbox(other_pay_interval?),
    }.symbolize_keys
  end

  private

  attr_reader :member, :position

  def other_pay_interval?
    member.employed_pay_interval != "Hour" &&
      member.employed_pay_interval != "Year"
  end

  def boolean_to_checkbox(statement)
    if statement == true
      "Yes"
    end
  end
end
