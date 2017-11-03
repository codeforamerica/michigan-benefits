class ExtraEmployedMemberAttributes
  def initialize(member:)
    @member = member
  end

  def title
    "Employment details for household member: #{member.display_name}"
  end

  def to_a
    [
      "Employer name: #{member.employed_employer_name}",
      "Average number of hours expected to work:" +
        " #{member.employed_hours_per_week} (per week)",
      "Rate of pay: $#{member.employed_pay_quantity}",
      "Pay interval: #{member.employed_pay_interval}",
    ]
  end

  private

  attr_reader :member
end
