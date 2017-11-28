class ClientEmailApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |benefit_application, logger|
      ApplicationMailer.snap_application_notification(
        file_name: benefit_application.pdf.path,
        recipient_email: benefit_application.email,
      ).deliver

      logger.info("Emailed to #{benefit_application.email}")
    end
  end
end
