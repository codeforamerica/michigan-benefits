class FaxApplicationJob < ApplicationJob
  def perform(snap_application_id:)
    @snap_application = SnapApplication.find(snap_application_id)
    return if snap_application.faxed?
    create_pdf
    fax_pdf
    snap_application.update(faxed_at: Time.zone.now)
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

  def fax_pdf
    Fax.send_fax(
      number: fax_number,
      file: complete_form_with_cover.path,
      recipient: fax_recipient_name,
    )
  end

  def fax_recipient
    FaxRecipient.new(residential_address: residential_address)
  end

  def fax_recipient_name
    fax_recipient.name
  end

  def fax_number
    fax_recipient.number
  end
end
