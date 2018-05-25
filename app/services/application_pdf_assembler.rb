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
    components = [
      Coversheet.new,
      AssistanceApplicationForm.new(benefit_application),
    ]
    if benefit_application.applying_for_food_assistance?
      components << FoodAssistanceSupplement.new(benefit_application)
    end
    if benefit_application.applying_for_healthcare?
      components << HealthcareCoverageSupplement.new(benefit_application)
    end
    components << verification_documents
    components.flatten
  end

  def verification_documents
    benefit_application.paperwork.map do |document_url|
      VerificationDocument.new(url: document_url, benefit_application: benefit_application)
    end
  end
end
