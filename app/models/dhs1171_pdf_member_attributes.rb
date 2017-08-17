class Dhs1171PdfMemberAttributes
  def initialize(member:, position:)
    @member = member
    @position = position
  end

  def to_h
    {
      "#{position}_member_full_name" => member.full_name,
      "#{position}_member_sex_male" =>
        boolean_to_checkbox(member.sex == "male"),
      "#{position}_member_sex_female" =>
        boolean_to_checkbox(member.sex == "female"),
      "#{position}_member_birthday" => member.birthday.strftime("%m/%d/%Y"),
      "#{position}_member_relationship" => member.relationship,
      "#{position}_member_ssn" => member.ssn,
      "#{position}_member_marital_status_married" =>
        boolean_to_checkbox(member.marital_status == "Married"),
      "#{position}_member_marital_status_never_married" =>
        boolean_to_checkbox(member.marital_status == "Never married"),
      "#{position}_member_marital_status_divorced" =>
        boolean_to_checkbox(member.marital_status == "Divorced"),
      "#{position}_member_marital_status_widowed" =>
        boolean_to_checkbox(member.marital_status == "Widowed"),
      "#{position}_member_marital_status_separated" =>
        boolean_to_checkbox(member.marital_status == "Separated"),
      "#{position}_member_citizen_yes" => boolean_to_checkbox(member.citizen?),
      "#{position}_member_citizen_no" => boolean_to_checkbox(!member.citizen?),
      "#{position}_member_new_mom_yes" => boolean_to_checkbox(member.new_mom?),
      "#{position}_member_new_mom_no" => boolean_to_checkbox(!member.new_mom?),
      "#{position}_member_in_college_yes" =>
        boolean_to_checkbox(member.in_college?),
      "#{position}_member_in_college_no" =>
        boolean_to_checkbox(!member.in_college?),
      "#{position}_member_requesting_food_assistance" =>
        boolean_to_checkbox(member.requesting_food_assistance?),
    }.symbolize_keys
  end

  private

  attr_reader :member, :position

  def boolean_to_checkbox(statement)
    if statement == true
      "Yes"
    end
  end
end
