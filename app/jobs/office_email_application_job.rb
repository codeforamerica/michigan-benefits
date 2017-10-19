class OfficeEmailApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |snap_application, logger|
      ApplicationMailer.office_application_notification(
        file_name: snap_application.pdf.path,
        recipient_email: snap_application.receiving_office_email,
        office_location: snap_application.office_location,
      ).deliver

      logger.info("Emailed to #{snap_application.receiving_office_email} "\
                  "for Snap Client #{snap_application.id}")
    end
  end
end
