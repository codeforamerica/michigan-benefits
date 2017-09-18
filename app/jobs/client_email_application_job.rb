class ClientEmailApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |snap_application, logger|
      ApplicationMailer.snap_application_notification(
        file_name: snap_application.pdf.path,
        recipient_email: snap_application.email,
      ).deliver

      logger.info("Emailed to #{snap_application.email}")
    end
  end
end
