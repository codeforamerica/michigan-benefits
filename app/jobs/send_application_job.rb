class SendApplicationJob < ApplicationJob
  def perform(snap_application:)
    create_pdf(snap_application)
    send_pdf(snap_application)
    destroy_pdf
  end

  private

  def create_pdf(snap_application)
    Dhs1171Pdf.new(
      snap_application: snap_application,
      output_filename: new_file_name,
    ).save
  end

  def send_pdf(snap_application)
    ApplicationMailer.snap_application_notification(
      file_name: "tmp/#{new_file_name}",
      recipient_email: snap_application.email,
    ).deliver
  end

  def destroy_pdf
    # delete pdf
  end

  def new_file_name
    "test_pdf.pdf"
  end
end
