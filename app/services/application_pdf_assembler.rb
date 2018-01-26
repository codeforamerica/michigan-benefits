class ApplicationPdfAssembler
  def initialize(benefit_application:)
    @benefit_application = benefit_application
  end

  def run
    PdfConcatenator.new(components).run
  end

  attr_reader :benefit_application

  private

  def components
    [
      Coversheet.new,
      AssistanceApplicationForm.new(benefit_application),
      # CommonApplicationAdditionalMembers.new(benefit_application.members),
      # MedicaidSupplement.new(medicaid_application) if medicaid_application,
      # FoodAssistanceSupplement.new(benefit_application) if benefit_application,
      verification_documents,
    ].flatten
  end

  def verification_documents
    benefit_application.documents.map do |document_url|
      VerificationDocument.new(url: document_url, benefit_application: benefit_application)
    end
  end
end
