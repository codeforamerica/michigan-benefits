class EmailApplicationJob < ApplicationJob
  def perform(snap_application:)
    @snap_application = snap_application

    create_pdf
    send_pdf
  ensure
    complete_form_with_cover.try(:close)
    complete_form_with_cover.try(:unlink)
  end

  private

  attr_reader :complete_form_with_cover, :snap_application
  delegate :residential_address, to: :snap_application

  def create_pdf
    @complete_form_with_cover = Dhs1171Pdf.new(
      snap_application: snap_application,
    ).completed_file
  end

  def send_pdf
    ApplicationMailer.snap_application_notification(
      file_name: complete_form_with_cover.path,
      recipient_email: snap_application.email,
    ).deliver
  end
end
