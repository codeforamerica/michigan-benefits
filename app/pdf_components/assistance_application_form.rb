class AssistanceApplicationForm
  include PdfAttributes

  def fill?
    true
  end

  def initialize(benefit_application)
    @benefit_application = benefit_application
  end

  def source_pdf_path
    "app/lib/pdfs/AssistanceApplication.pdf"
  end

  def attributes
    applicant_registration_attributes
  end

  def applicant_registration_attributes
    {
      applying_for_food: "Yes",
      legal_name: benefit_application.display_name,
    }
  end

  def output_file
    @_output_file ||= Tempfile.new(["assistance_app", ".pdf"], "tmp/")
  end

  private

  attr_reader :benefit_application
end
