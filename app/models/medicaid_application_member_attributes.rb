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
      :"#{position}_member_employed" => bool_to_checkbox(member.employed?),
      :"#{position}_member_not_employed" => bool_to_checkbox(!member.employed?),
      :"#{position}_member_self_employed" =>
        bool_to_checkbox(member.self_employed?),
      :"#{position}_member_additional_income_none" =>
        bool_to_checkbox(!member.other_income?),
      :"#{position}_member_additional_income_unemployment_amount" =>
        member.unemployment_income,
      :"#{position}_member_deduction_student_loan_yes" =>
        bool_to_checkbox(member.pay_student_loan_interest?),
      :"#{position}_member_deduction_alimony_yes" =>
        bool_to_checkbox(member.pay_child_support_alimony_arrears?),
    }

    if member.ssn.present?
      member.ssn.split("").each_with_index do |ssn_digit, index|
        member_attributes[:"#{position}_member_ssn_#{index}"] = ssn_digit
      end
    end

    if member.birthday.present?
      member_attributes[:"#{position}_member_birthday"] =
        MemberDecorator.new(member).formatted_birthday
      member_attributes[:"#{position}_member_under_21_#{yes_no(under_21?)}"] =
        "Yes"
    end

    member_attributes.merge!(
      employment_attributes(
        employment: member.employments.first,
        job_position: "first",
      ),
    )
    member_attributes.merge!(
      employment_attributes(
        employment: member.employments.second,
        job_position: "second",
      ),
    )

    if member.other_income?
      member.other_income_types.each do |other_income_type|
        pdf_income_type_key =
          :"#{position}_member_additional_income_#{other_income_type}"
        member_attributes[pdf_income_type_key] = "Yes"
      end
    end

    if member.unemployment_income?
      unemployment_income_interval_key =
        :"#{position}_member_additional_income_unemployment_interval"
      member_attributes[unemployment_income_interval_key] = "Monthly"
    end

    if member.pay_student_loan_interest?
      student_loan_amount_key =
        :"#{position}_member_deduction_student_loan_interest_amount"
      member_attributes[student_loan_amount_key] =
        member.student_loan_interest_expenses
      student_loan_interval_key =
        :"#{position}_member_deduction_student_loan_interest_interval"
      member_attributes[student_loan_interval_key] = "Monthly"
    end

    if member.pay_child_support_alimony_arrears?
      child_support_amount_key =
        :"#{position}_member_deduction_child_support_alimony_arrears_amount"
      member_attributes[child_support_amount_key] =
        member.child_support_alimony_arrears_expenses
      child_support_interval_key =
        :"#{position}_member_deduction_child_support_alimony_arrears_interval"
      member_attributes[child_support_interval_key] = "Monthly"
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

  def employment_attributes(employment:, job_position:)
    return {} if employment.nil?

    interval = pay_interval(employment.payment_frequency)
    {
      :"#{position}_member_#{job_position}_employed_employer_name" =>
        employment.employer_name,
      :"#{position}_member_#{job_position}_employed_pay_quantity" =>
        employment.pay_quantity,
      :"#{position}_member_#{job_position}_employed_pay_interval_#{interval}" =>
        "Yes",
    }
  end

  def pay_interval(interval)
    translated_intervals = {
      "Hourly" => "hourly",
      "Weekly" => "weekly",
      "Every Two Weeks" => "biweekly",
      "Twice a Month" => "twice_monthly",
      "Monthly" => "monthly",
      "Yearly" => "yearly",
    }

    translated_intervals[interval]
  end
end
