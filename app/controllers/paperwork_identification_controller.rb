class PaperworkIdentificationController < SnapStepsController
  private

  def skip?
    current_application.applied_before_yes?
  end
end
