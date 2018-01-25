class ClientEmailApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |snap_application, logger|
      ApplicationMailer.snap_application_notification(
        application_pdf: snap_application.pdf,
        recipient_email: snap_application.email,
      ).deliver

      logger.info("Emailed to #{snap_application.email}")
    end
  end
end
