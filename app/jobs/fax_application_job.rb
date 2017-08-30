class FaxApplicationJob < ApplicationJob
  def perform(snap_application_id:)
    @snap_application = SnapApplication.find(snap_application_id)
    return if snap_application.faxed?
    fax_pdf
    snap_application.update(faxed_at: Time.zone.now)
  ensure
    pdf.try(:close)
    pdf.try(:unlink)
  end

  private

  attr_reader :snap_application
  delegate :pdf, :residential_address, to: :snap_application

  def fax_pdf
    Fax.send_fax(
      number: fax_number,
      file: pdf.path,
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
