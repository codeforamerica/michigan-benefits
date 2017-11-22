class ExtraMemberAttributes
  def initialize(member:)
    @member = member
  end

  def title
    "Details for household member: #{member.display_name}"
  end

  def to_a
    [
      "1. Name: #{member.display_name}",
      "2. Date of birth: #{formatted_birthday(member)}",
      "3. Relationship: #{relationship(member)}",
      "4. Sex: #{member.sex}",
      "5. Social security number: #{member.ssn}",
      "6. Marital status: #{member.marital_status}",
      "7. US Citizen: #{boolean_to_string(member.citizen?)}",
      "8. Pregnant now/last 2 months: #{boolean_to_string(member.new_mom?)}",
      "10. In school now: #{boolean_to_string(member.in_college?)}",
      "16. Type of help needed: #{requested_assistance(member)}",
    ]
  end

  private

  attr_reader :member

  def formatted_birthday(member)
    MemberDecorator.new(member).formatted_birthday
  end

  def relationship(member)
    member.relationship || "SELF"
  end

  def boolean_to_string(attribute)
    if attribute == true
      "Yes"
    else
      "No"
    end
  end

  def requested_assistance(member)
    if member.requesting_food_assistance?
      "Food"
    end
  end
end
