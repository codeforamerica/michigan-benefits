class AssistanceApplicationForm
  include Integrated::PdfAttributes

  def initialize(benefit_application)
    @benefit_application = benefit_application
  end

  def source_pdf_path
    "app/lib/pdfs/AssistanceApplication.pdf"
  end

  def fill?
    true
  end

  def attributes
    applicant_registration_attributes.
      merge(member_attributes).
      merge(medical_expenses_attributes).
      merge(medical_expenses_details).
      merge(additional_expenses_attributes).
      merge(employed_attributes).
      merge(self_employed_attributes).
      merge(assets_attributes).
      merge(additional_income_attributes).
      merge(additional_notes_attributes)
  end

  def output_file
    @_output_file ||= Tempfile.new(["assistance_app", ".pdf"], "tmp/")
  end

  private

  attr_reader :benefit_application

  def applicant_registration_attributes
    {
      applying_for_food: yes_if_true(benefit_application.primary_member.requesting_food_yes?),
      applying_for_healthcare: yes_if_true(benefit_application.primary_member.requesting_healthcare_yes?),
      legal_name: benefit_application.display_name,
      residential_address_street: benefit_application.residential_address&.street_address,
      residential_address_apt: benefit_application.residential_address&.street_address_2,
      residential_address_city: benefit_application.residential_address&.city,
      residential_address_county: benefit_application.residential_address&.county,
      residential_address_state: benefit_application.residential_address&.state,
      residential_address_zip: benefit_application.residential_address&.zip,
      mailing_address: formatted_full_address(benefit_application.mailing_address),
      dob: mmddyyyy_date(benefit_application.primary_member.birthday),
      ssn: formatted_ssn(benefit_application.primary_member.ssn),
      completion_signature_applicant: benefit_application.signature,
      completion_signature_date: mmddyyyy_date(benefit_application.signed_at),
      received_assistance: yes_no_or_unfilled(
        yes: benefit_application.previously_received_assistance_yes?,
        no: benefit_application.previously_received_assistance_no?,
      ),
      is_homeless: yes_no_or_unfilled(
        yes: benefit_application.homeless? || benefit_application.temporary_address?,
        no: benefit_application.stable_address?,
      ),
      anyone_in_college: yes_no_or_unfilled(yes_no_for(:student)),
      anyone_in_college_names: member_names(benefit_application.members.select(&:student_yes?)),
      anyone_disabled: yes_no_or_unfilled(yes_no_for(:disabled)),
      anyone_disabled_names: member_names(benefit_application.members.select(&:disabled_yes?)),
      anyone_a_veteran: yes_no_or_unfilled(yes_no_for(:veteran)),
      anyone_a_veteran_names: member_names(benefit_application.members.select(&:veteran_yes?)),
      anyone_recently_pregnant: yes_no_or_unfilled(
        yes: benefit_application.members.any?(&:pregnant_yes?) ||
          benefit_application.members.any?(&:pregnancy_expenses_yes?),
        no: benefit_application.members.none?(&:pregnant_yes?) &&
          benefit_application.members.none?(&:pregnancy_expenses_yes?),
      ),
      anyone_recently_pregnant_names: member_names(recently_pregnant_members),
      anyone_medical_expenses: yes_no_or_unfilled(
        yes: benefit_application.expenses.medical.any? || benefit_application.members.any?(&:pregnancy_expenses_yes?),
        no: benefit_application.expenses.medical.none? && benefit_application.members.none(&:pregnancy_expenses_yes?),
      ),
      medical_expenses_other: yes_if_true(benefit_application.members.any?(&:pregnancy_expenses_yes?)),
      anyone_income_change: yes_no_or_unfilled(
        yes: benefit_application.income_changed_yes?,
        no: benefit_application.income_changed_no?,
      ),
      anyone_income_change_explanation: benefit_application.income_changed_explanation,
      wants_authorized_representative: yes_no_or_unfilled(
        yes: benefit_application.authorized_representative_yes?,
        no: benefit_application.authorized_representative_no?,
      ),
      authorized_representative_full_name: benefit_application.authorized_representative_name,
      authorized_representative_phone_number: formatted_phone(benefit_application.authorized_representative_phone),
      anyone_expenses_dependent_care: yes_no_or_unfilled(
        yes: benefit_application.expenses.dependent_care.any?,
        no: benefit_application.expenses.dependent_care.none?,
      ),
      anyone_court_expenses: yes_no_or_unfilled(
        yes: benefit_application.expenses.court_ordered.any?,
        no: benefit_application.expenses.court_ordered.none?,
      ),
      anyone_student_loans_deductions: yes_no_or_unfilled(
        yes: benefit_application.expenses.student_loan_interest.any?,
        no: benefit_application.expenses.student_loan_interest.none?,
      ),
    }
  end

  def member_attributes
    ordinals = ["first", "second", "third", "fourth", "fifth"]
    hash = {}
    benefit_application.members.first(5).each_with_index do |member, i|
      prefix = "#{ordinals[i]}_member"
      hash[:"#{prefix}_relation"] = member.relationship_label
      hash[:"#{prefix}_legal_name"] = member.display_name
      hash[:"#{prefix}_dob"] = mmddyyyy_date(member.birthday)
      hash[:"#{prefix}_male"] = circle_if_true(member.sex_male?)
      hash[:"#{prefix}_female"] = circle_if_true(member.sex_female?)
      hash[:"#{prefix}_married_yes"] = circle_if_true(member.married_yes?)
      hash[:"#{prefix}_married_no"] = circle_if_true(member.married_no?)
      hash[:"#{prefix}_citizen_yes"] = circle_if_true(member.citizen_yes?)
      hash[:"#{prefix}_citizen_no"] = circle_if_true(member.citizen_no?)
      hash[:"#{prefix}_requesting_food"] = underline_if_true(member.requesting_food_yes?)
      hash[:"#{prefix}_requesting_healthcare"] = underline_if_true(member.requesting_healthcare_yes?)
    end
    hash
  end

  def medical_expenses_attributes
    {}.tap do |hash|
      if benefit_application.members.any?(&:pregnancy_expenses_yes?)
        hash["medical_expenses_other_medical"] = "Yes"
      end
      benefit_application.expenses.medical.map(&:expense_type).each do |expense|
        hash["medical_expenses_#{expense}".to_sym] = "Yes"
      end
    end
  end

  def medical_expenses_details
    ordinals = ["first", "second"]
    hash = {}
    members = benefit_application.members.select(&:pregnancy_expenses_yes?)
    members.first(2).each_with_index do |member, i|
      prefix = "#{ordinals[i]}_member"
      hash[:"#{prefix}_medical_expenses_name"] = member.display_name
      hash[:"#{prefix}_medical_expenses_type"] = "Pregnancy-related"
    end
    hash
  end

  def additional_expenses_attributes
    {}.tap do |hash|
      benefit_application.expenses.dependent_care.map(&:expense_type).each do |expense|
        hash["dependent_care_#{expense}".to_sym] = "Yes"
      end

      benefit_application.expenses.court_ordered.map(&:expense_type).each do |expense|
        hash["court_expenses_#{expense}".to_sym] = "Yes"
      end
    end
  end

  def employed_attributes
    ordinals = ["first", "second"]
    hash = {
      anyone_employed: yes_no_or_unfilled(
        yes: benefit_application.anyone_employed?,
        no: !benefit_application.anyone_employed?,
      ),
    }
    members = benefit_application.members.select { |member| member.employments.any? }
    members.first(2).each_with_index do |member, i|
      hash[:"#{ordinals[i]}_member_employment_name"] = member.display_name
    end
    hash
  end

  def self_employed_attributes
    ordinals = ["first", "second"]
    hash = {
      anyone_self_employed: yes_no_or_unfilled(
        yes: benefit_application.members.any?(&:self_employed_yes?),
        no: benefit_application.members.none?(&:self_employed_yes?),
      ),
    }
    members = benefit_application.members.select(&:self_employed_yes?)
    members.first(2).each_with_index do |member, i|
      hash[:"#{ordinals[i]}_member_self_employed_name"] = member.display_name
    end
    hash
  end

  def assets_attributes
    {}.tap do |hash|
      hash[:anyone_assets_property] = yes_no_or_unfilled(
        yes: benefit_application.properties.any?,
        no: benefit_application.properties.none?,
      )

      benefit_application.properties.each do |property_type|
        hash["assets_property_#{property_type}".to_sym] = "Yes"
      end
    end
  end

  def additional_income_attributes
    ordinals = ["first", "second"]
    hash = {
      anyone_additional_income: yes_no_or_unfilled(
        yes: benefit_application.anyone_additional_income?,
        no: !benefit_application.anyone_additional_income?,
      ),
    }
    Income::INCOME_SOURCES.each_key do |key|
      hash[:"additional_income_#{key}"] = yes_if_true(benefit_application.anyone_additional_income_of?(key))
    end
    members = benefit_application.members.select { |member| member.incomes.any? }
    members.first(2).each_with_index do |member, i|
      hash[:"#{ordinals[i]}_member_additional_income_name"] = member.display_name
      hash[:"#{ordinals[i]}_member_additional_income_type"] = member.incomes.map(&:display_name).join(", ")
    end
    hash
  end

  def additional_notes_attributes
    @_additional_notes = {
      notes: "",
    }
    add_additional_household_members
    add_additional_medical_expenses
    add_additional_members_healthcare_enrolled
    add_additional_members_flint_water
    add_additional_members_employed
    add_additional_members_self_employed
    add_additional_members_additional_income
    @_additional_notes
  end

  def add_additional_household_members
    if benefit_application.members.count > 5
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Household Members:"
      benefit_application.members[5..-1].each do |extra_member|
        @_additional_notes[:notes] += "\n- Relation: #{extra_member.relationship_label}, "
        @_additional_notes[:notes] += "Legal name: #{extra_member.display_name}, "
        @_additional_notes[:notes] += "Sex: #{extra_member.sex.titleize}, "
        @_additional_notes[:notes] += "DOB: #{mmddyyyy_date(extra_member.birthday)}, "
        @_additional_notes[:notes] += "Married: #{extra_member.married.titleize}, "
        @_additional_notes[:notes] += "Citizen: #{extra_member.citizen.titleize}, "
        if extra_member.requesting_food_yes? || extra_member.requesting_healthcare_yes?
          programs = %w{Food Healthcare}.select do |program|
            extra_member.public_send(:"requesting_#{program.downcase}_yes?")
          end
          @_additional_notes[:notes] += "Applying for: #{programs.join(', ')}\n"
        end
      end
    end
  end

  def add_additional_medical_expenses
    members = benefit_application.members.select(&:pregnancy_expenses_yes?)
    if members.count > 2
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Medical Expenses:\n"
      @_additional_notes[:notes] += members[2..-1].map do |extra_member|
        "- #{extra_member.display_name}, Pregnancy-related\n"
      end.join
    end
  end

  def add_additional_members_healthcare_enrolled
    members = benefit_application.members.select(&:healthcare_enrolled_yes?)
    if members.count > 3
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Members Currently Enrolled in Health Coverage:\n"
      @_additional_notes[:notes] += members[3..-1].map do |extra_member|
        "- #{extra_member.display_name}\n"
      end.join
    end
  end

  def add_additional_members_flint_water
    members = benefit_application.members.select(&:flint_water_yes?)
    if members.count > 2
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Members Affected by the Flint Water Crisis:\n"
      @_additional_notes[:notes] += members[2..-1].map do |extra_member|
        "- #{extra_member.display_name}\n"
      end.join
    end
  end

  def add_additional_members_employed
    members = benefit_application.members.select { |member| member.employments.any? }
    if members.count > 2
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Employed Members:\n"
      @_additional_notes[:notes] += members[2..-1].map do |extra_member|
        "- #{extra_member.display_name}\n"
      end.join
    end
  end

  def add_additional_members_self_employed
    members = benefit_application.members.select(&:self_employed_yes?)
    if members.count > 2
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Self-Employed Members:\n"
      @_additional_notes[:notes] += members[2..-1].map do |extra_member|
        "- #{extra_member.display_name}\n"
      end.join
    end
  end

  def add_additional_members_additional_income
    members = benefit_application.members.select { |member| member.incomes.any? }
    if members.count > 2
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Members with Additional Income:\n"
      @_additional_notes[:notes] += members[2..-1].map do |extra_member|
        "- #{extra_member.display_name} (#{extra_member.incomes.map(&:display_name).join(', ')})\n"
      end.join
    end
  end

  def recently_pregnant_members
    benefit_application.members.select do |member|
      member.pregnant_yes? || member.pregnancy_expenses_yes?
    end
  end

  def formatted_phone(phone)
    return nil if phone.blank?
    "(#{phone[0..2]}) #{phone[3..5]}-#{phone[6..9]}"
  end

  def formatted_ssn(ssn)
    return nil if ssn.blank?
    "#{ssn[0..2]}-#{ssn[3..4]}-#{ssn[5..8]}"
  end

  def formatted_full_address(address)
    return "" if address.nil?
    [address.street_address, address.street_address_2, address.city, address.state].
      reject(&:blank?).
      join(", ").
      concat(" #{address.zip}")
  end
end
