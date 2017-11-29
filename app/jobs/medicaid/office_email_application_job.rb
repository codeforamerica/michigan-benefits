module Medicaid
  class OfficeEmailApplicationJob < ApplicationJob
    def perform(export:)
      export.execute do |medicaid_application, logger|
        ApplicationMailer.office_medicaid_application_notification(
          file_name: medicaid_application.pdf.path,
          recipient_email: medicaid_application.receiving_office_email,
        ).deliver

        logger.info(
          "Emailed to #{medicaid_application.receiving_office_email} "\
          "for Medicaid Client #{medicaid_application.id}",
        )
      end
    end
  end
end
