class MedicaidApplicationMemberAttributes
  include PdfAttributes

  def initialize(member:, position:)
    @member = member
    @position = position
  end

  def to_h
    member_attributes = {
      :"#{position}_member_full_name" => member.display_name,
      :"#{position}_member_sex_male" => bool_to_checkbox(member.male?),
      :"#{position}_member_sex_female" => bool_to_checkbox(member.female?),
      :"#{position}_member_married_#{yes_no(member.married)}" => "Yes",
      :"#{position}_member_spouse_name" => member.spouse&.display_name,
      member_caretaker_key => "Yes",
      :"#{position}_member_in_college_#{yes_no(member.in_college)}" => "Yes",
      :"#{position}_member_new_mom_#{yes_no(member.new_mom?)}" => "Yes",
      requesting_health_insurance_key => "Yes",
      :"#{position}_member_citizen_#{yes_no(member.citizen?)}" => "Yes",
    }

    if member.ssn.present?
      member.ssn.split("").each_with_index do |ssn_digit, index|
        member_attributes[:"#{position}_member_ssn_#{index}"] = ssn_digit
      end
    end

    if member.birthday.present?
      member_attributes[:"#{position}_member_birthday"] =
        member.formatted_birthday
      member_attributes[:"#{position}_member_under_21_#{yes_no(under_21?)}"] =
        "Yes"
    end

    member_attributes
  end

  private

  attr_reader :member, :position

  def member_caretaker_key
    :"#{position}_member_caretaker_#{yes_no(member.caretaker_or_parent)}"
  end

  def requesting_health_insurance_key
    yes_no = yes_no(member.requesting_health_insurance?)
    :"#{position}_member_requesting_health_insurance_#{yes_no}"
  end

  def under_21?
    member.age < 21
  end
end
