class ExtraSelfEmployedMemberAttributes
  def initialize(member:)
    @member = member
  end

  def title
    "Self-Employment income details for household member: " +
      member.display_name
  end

  def to_a
    [
      "Type of work: #{member.self_employed_profession}",
      "Gross monthly income: $#{member.self_employed_monthly_income}",
      "Monthly self-employment expenses:" +
        " $#{member.self_employed_monthly_expenses}",
    ]
  end

  private

  attr_reader :member
end
