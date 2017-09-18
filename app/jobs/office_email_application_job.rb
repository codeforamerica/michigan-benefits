class OfficeEmailApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |snap_application|
      ApplicationMailer.office_application_notification(
        file_name: snap_application.pdf.path,
        recipient_email: snap_application.receiving_office_email,
      ).deliver

      "Emailed to #{snap_application.receiving_office_email}"
    end
  end
end
