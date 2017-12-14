class SnapApplicationMemberAttributes
  include PdfAttributes

  def initialize(member:, position:)
    @member = member
    @position = position
  end

  private

  attr_reader :member, :position

  def attributes
    [
      {
        "#{position}_member_full_name" => member.display_name,
        "#{position}_member_sex_male" => bool_to_checkbox(member.sex == "male"),
        "#{position}_member_sex_female" =>
        bool_to_checkbox(member.sex == "female"),
        "#{position}_member_birthday" => member.birthday.strftime("%m/%d/%Y"),
        "#{position}_member_relationship" => member.relationship,
        "#{position}_member_marital_status_married" =>
          bool_to_checkbox(member.marital_status == "Married"),
        "#{position}_member_marital_status_never_married" =>
          bool_to_checkbox(member.marital_status == "Never married"),
        "#{position}_member_marital_status_divorced" =>
          bool_to_checkbox(member.marital_status == "Divorced"),
        "#{position}_member_marital_status_widowed" =>
          bool_to_checkbox(member.marital_status == "Widowed"),
        "#{position}_member_marital_status_separated" =>
          bool_to_checkbox(member.marital_status == "Separated"),
        "#{position}_member_requesting_food_assistance" =>
          bool_to_checkbox(member.requesting_food_assistance?),
      },
      ssn_attributes,
      yes_no_checkbox("#{position}_member_citizen", member.citizen?),
      yes_no_checkbox("#{position}_member_new_mom", member.new_mom?),
      yes_no_checkbox("#{position}_member_in_college", member.in_college?),
    ]
  end

  def ssn_attributes
    if member.ssn.present?
      ssn_list = member.ssn.split("")
      ssn_list.each_with_index.reduce({}) do |memo, (ssn_digit, index)|
        memo["#{position}_member_ssn_#{index}"] = ssn_digit
        memo
      end
    else
      {}
    end
  end
end
