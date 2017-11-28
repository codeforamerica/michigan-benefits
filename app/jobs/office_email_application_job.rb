class OfficeEmailApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |benefit_application, logger|
      if benefit_application.class == SnapApplication
        ApplicationMailer.office_snap_application_notification(
          file_name: benefit_application.pdf.path,
          recipient_email: benefit_application.receiving_office_email,
          office_location: benefit_application.office_location,
        ).deliver

        logger.info("Emailed to #{benefit_application.receiving_office_email} "\
                    "for Snap Client #{benefit_application.id}")
      else
        ApplicationMailer.office_medicaid_application_notification(
          file_name: benefit_application.pdf.path,
          recipient_email: benefit_application.receiving_office_email,
        ).deliver

        logger.info("Emailed to #{benefit_application.receiving_office_email} "\
                    "for Medicaid Client #{benefit_application.id}")
      end
    end
  end
end
