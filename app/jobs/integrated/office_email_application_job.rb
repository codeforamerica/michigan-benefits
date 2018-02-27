module Integrated
  class OfficeEmailApplicationJob < ApplicationJob
    def perform(export:)
      export.execute do |integrated_application, logger|
        ApplicationMailer.office_integrated_application_notification(
          application_pdf: integrated_application.pdf,
          recipient_email: integrated_application.receiving_office_email,
          applicant_name: integrated_application.primary_member.display_name,
        ).deliver

        logger.info(
          "Emailed to #{integrated_application.receiving_office_email} "\
          "for FAP + Medicaid Client #{integrated_application.id}",
        )
      end
    end
  end
end
