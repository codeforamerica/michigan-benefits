class SendApplicationJob < ApplicationJob
  def perform(snap_application:)
    @snap_application = snap_application

    create_pdf
    send_pdf
    fax_pdf
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

  def fax_pdf
    if fax_phone_number_exists?
      Fax.send_fax(
        number: fax_recipient_number,
        file: complete_form_with_cover.path,
        recipient: fax_recipient_name,
      )
    end
  end

  def fax_recipient
    FaxRecipient.new(residential_address: residential_address)
  end

  def fax_recipient_name
    fax_recipient.name
  end

  def fax_recipient_number
    fax_recipient.number
  end

  def fax_phone_number_exists?
    !fax_recipient_number.empty?
  end
end
