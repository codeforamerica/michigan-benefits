module Integrated
  class ClientEmailApplicationJob < ApplicationJob
    def perform(export:)
      export.execute do |integrated_application, logger|
        ApplicationMailer.client_integrated_application_notification(
          application_pdf: integrated_application.pdf,
          recipient_email: integrated_application.email,
        ).deliver

        logger.info(
          "Emailed to #{integrated_application.email} "\
          "for FAP + Medicaid Client #{integrated_application.id}",
        )
      end
    end
  end
end
