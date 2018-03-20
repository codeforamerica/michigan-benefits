class HealthcareCoverageSupplement
  include Integrated::PdfAttributes

  def initialize(benefit_application)
    @benefit_application = benefit_application
  end

  def source_pdf_path
    "app/lib/pdfs/HealthcareCoverageSupplement.pdf"
  end

  def fill?
    true
  end

  def attributes
    supplement_attributes
  end

  def output_file
    @_output_file ||= Tempfile.new(["healthcare_coverage_supplement", ".pdf"], "tmp/")
  end

  private

  attr_reader :benefit_application

  def supplement_attributes
    {
      anyone_filing_taxes: yes_no_or_unfilled(
        yes: benefit_application.primary_member.filing_taxes_next_year_yes?,
        no: benefit_application.primary_member.filing_taxes_next_year_no?,
      ),
      filing_taxes_primary_filer_name: primary_tax_filer_name,
    }
  end

  def primary_tax_filer_name
    benefit_application.primary_member.display_name if benefit_application.primary_member.filing_taxes_next_year_yes?
  end
end
