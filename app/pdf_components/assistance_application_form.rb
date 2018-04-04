class AssistanceApplicationForm
  include AssistanceApplicationFormDefaults
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
      dob: mmddyyyy_date(benefit_application.primary_member.birthday),
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
      anyone_medical_expenses: yes_no_or_unfilled(yes_no_for(:pregnancy_expenses)),
      medical_expenses_other: yes_if_true(benefit_application.members.any?(&:pregnancy_expenses_yes?)),

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

  def additional_notes_attributes
    hash = {
      notes: "",
    }

    if benefit_application.members.count > 5
      hash[:household_added_notes] = "Yes"
      hash[:notes] += "Additional Household Members:"
      benefit_application.members[5..-1].each do |extra_member|
        hash[:notes] += "\n- Relation: #{extra_member.relationship_label}, "
        hash[:notes] += "Legal name: #{extra_member.display_name}, "
        hash[:notes] += "Sex: #{extra_member.sex.titleize}, "
        hash[:notes] += "DOB: #{mmddyyyy_date(extra_member.birthday)}, "
        hash[:notes] += "Married: #{extra_member.married.titleize}, "
        hash[:notes] += "Citizen: #{extra_member.citizen.titleize}, "
        if extra_member.requesting_food_yes? || extra_member.requesting_healthcare_yes?
          programs = %w{Food Healthcare}.select do |program|
            extra_member.public_send(:"requesting_#{program.downcase}_yes?")
          end
          hash[:notes] += "Applying for: #{programs.join(', ')}\n"
        end
      end
    end

    members_with_pregnancy_expenses = benefit_application.members.select(&:pregnancy_expenses_yes?)
    if members_with_pregnancy_expenses.count > 2
      hash[:household_added_notes] = "Yes"
      hash[:notes] += "Additional Medical Expenses:\n"
      hash[:notes] += members_with_pregnancy_expenses[2..-1].map do |extra_member|
        "- #{extra_member.display_name}, Pregnancy-related\n"
      end.join
    end

    hash
  end

  def recently_pregnant_members
    benefit_application.members.select do |member|
      member.pregnant_yes? || member.pregnancy_expenses_yes?
    end
  end

  def yes_no_for(field)
    {
      yes: benefit_application.members.any?(&:"#{field}_yes?"),
      no: benefit_application.members.all?(&:"#{field}_no?"),
    }
  end
end
