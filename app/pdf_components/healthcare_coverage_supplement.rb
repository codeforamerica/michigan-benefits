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
      primary_filer_filing_jointly: yes_no_or_unfilled(
        yes: benefit_application.filing_taxes_jointly?,
        no: !benefit_application.filing_taxes_jointly?,
      ),
      primary_filer_filing_jointly_spouse_name:
        benefit_application.spouse_filing_taxes_jointly&.display_name,
      primary_filer_claiming_dependents: yes_no_or_unfilled(
        yes: benefit_application.filing_taxes_with_dependent?,
        no: !benefit_application.filing_taxes_with_dependent?,
      ),
      primary_filer_claiming_dependents_dependents_names:
        benefit_application.dependents&.map { |dep| dep.display_name }&.join(", "),
    }.merge(second_filer_attributes)
  end

  def second_filer_attributes
    if benefit_application.filing_taxes_separately?
      {
        filing_taxes_second_filer_name:
          benefit_application.spouse_filing_taxes_separately&.display_name,
        second_filer_filing_jointly: "No",
      }
    else
      {}
    end
  end

  def primary_tax_filer_name
    benefit_application.primary_member.display_name if benefit_application.primary_member.filing_taxes_next_year_yes?
  end
end
