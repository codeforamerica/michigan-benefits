class OfficeLocationController < SnapStepsController
  private

  def skip?
    current_application.office_page.present?
  end
end
