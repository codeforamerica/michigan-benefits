class OfficeEmailApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |snap_application, logger|
      ApplicationMailer.office_snap_application_notification(
        application_pdf: snap_application.pdf,
        recipient_email: snap_application.receiving_office_email,
        office_location: snap_application.office_location,
        applicant_name: snap_application.primary_member.display_name,
      ).deliver

      logger.info("Emailed to #{snap_application.receiving_office_email} "\
                  "for Snap Client #{snap_application.id}")
    end
  end
end
