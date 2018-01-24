class ApplicationPdfAssembler
  def initialize(snap_application:)
    @snap_application = snap_application
  end

  def run
    PdfConcatenator.new(forms).run
  end

  attr_reader :snap_application

  private

  def forms
    [
      AssistanceApplicationForm.new(snap_application),
      # CommonApplicationAdditionalMembers.new(snap_application.members),
      # MedicaidSupplement.new(medicaid_application) if medicaid_application,
      # FoodAssistanceSupplement.new(snap_application) if snap_application,
      # VerificationPaperwork.new(snap_application.documents),
    ]
  end
end
