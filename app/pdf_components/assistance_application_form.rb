class AssistanceApplicationForm
  include PdfAttributes

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
      merge(first_member_attributes)
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
    }
  end

  def first_member_attributes
    {
      first_member_dob: mmddyyyy_date(benefit_application.primary_member.birthday),
      first_member_male: circle_if_true(benefit_application.primary_member.sex_male?),
      first_member_female: circle_if_true(benefit_application.primary_member.sex_female?),
      first_member_requesting_food: PdfAttributes::UNDERLINED,
    }
  end
end
