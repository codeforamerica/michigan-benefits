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
      merge(member_attributes)
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
      anyone_in_college: yes_no_or_unfilled(
        yes: benefit_application.members.any?(&:student_yes?),
        no: benefit_application.members.none?(&:student_yes?),
      ),
      anyone_in_college_names: member_names(benefit_application.members.select(&:student_yes?)),
      anyone_disabled: yes_no_or_unfilled(
        yes: benefit_application.members.any?(&:disabled_yes?),
        no: benefit_application.members.none?(&:disabled_yes?),
      ),
      anyone_disabled_names: member_names(benefit_application.members.select(&:disabled_yes?)),
      anyone_a_veteran: yes_no_or_unfilled(
        yes: benefit_application.members.any?(&:veteran_yes?),
        no: benefit_application.members.none?(&:veteran_yes?),
      ),
      anyone_a_veteran_names: member_names(benefit_application.members.select(&:veteran_yes?)),
      anyone_recently_pregnant: yes_no_or_unfilled(
        yes: benefit_application.members.any?(&:pregnant_yes?),
        no: benefit_application.members.none?(&:pregnant_yes?),
      ),
      anyone_recently_pregnant_names: member_names(benefit_application.members.select(&:pregnant_yes?)),
    }
  end

  def member_attributes
    ordinals = ["first", "second", "third", "fourth", "fifth"]
    hash = {}
    benefit_application.members.first(5).each_with_index do |member, i|
      prefix = "#{ordinals[i]}_member_"
      hash[:"#{prefix}relation"] = member.relationship_label
      hash[:"#{prefix}legal_name"] = member.display_name
      hash[:"#{prefix}dob"] = mmddyyyy_date(member.birthday)
      hash[:"#{prefix}male"] = circle_if_true(member.sex_male?)
      hash[:"#{prefix}female"] = circle_if_true(member.sex_female?)
      hash[:"#{prefix}married_yes"] = circle_if_true(member.married_yes?)
      hash[:"#{prefix}married_no"] = circle_if_true(member.married_no?)
      hash[:"#{prefix}citizen_yes"] = circle_if_true(member.citizen_yes?)
      hash[:"#{prefix}citizen_no"] = circle_if_true(member.citizen_no?)
      hash[:"#{prefix}requesting_food"] = underline_if_true(member.requesting_food_yes?)
      hash[:"#{prefix}requesting_healthcare"] = underline_if_true(member.requesting_healthcare_yes?)
    end
    if benefit_application.members.count > 5
      hash[:household_added_notes] = "Yes"
      hash[:notes] = "Additional Household Members:"
      benefit_application.members[5..-1].each do |extra_member|
        hash[:notes] += "\n- Relation: #{extra_member.relationship_label}, "
        hash[:notes] += "Legal name: #{extra_member.display_name}, "
        hash[:notes] += "Sex: #{extra_member.sex.titleize}, "
        hash[:notes] += "DOB: #{mmddyyyy_date(extra_member.birthday)}, "
        hash[:notes] += "Married: #{extra_member.married.titleize}, "
        hash[:notes] += "Citizen: #{extra_member.citizen.titleize}, "
        hash[:notes] += "Student: #{extra_member.student.titleize}, "
        hash[:notes] += "Disabled: #{extra_member.disabled.titleize}, "
        hash[:notes] += "Veteran: #{extra_member.veteran.titleize}, "
        hash[:notes] += "Pregnant: #{extra_member.pregnant.titleize}, "
        if extra_member.requesting_food_yes? || extra_member.requesting_healthcare_yes?
          programs = %w{Food Healthcare}.select do |program|
            extra_member.public_send(:"requesting_#{program.downcase}_yes?")
          end
          hash[:notes] += "Applying for: #{programs.join(', ')}\n"
        end
      end
    end
    hash
  end
end
