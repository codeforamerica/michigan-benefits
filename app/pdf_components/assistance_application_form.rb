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
      applying_for_food: "Yes",
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
      hash[:"#{prefix}requesting_food"] = Integrated::PdfAttributes::UNDERLINED
    end
    hash
  end
end
