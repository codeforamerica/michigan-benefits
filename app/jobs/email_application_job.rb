class EmailApplicationJob < ApplicationJob
  def perform(snap_application_id:)
    @snap_application = SnapApplication.find(snap_application_id)
    ApplicationMailer.snap_application_notification(
      file_name: snap_application.pdf.path,
      recipient_email: snap_application.email,
    ).deliver
  ensure
    snap_application.pdf.try(:close)
    snap_application.pdf.try(:unlink)
  end

  private

  attr_reader :snap_application
end
