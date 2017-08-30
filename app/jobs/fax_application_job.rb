class FaxApplicationJob < ApplicationJob
  def perform(snap_application_id:)
    @snap_application = SnapApplication.find(snap_application_id)
    return if snap_application.faxed?
    Fax.send_fax(
      number: fax_recipient.number,
      file: snap_application.pdf.path,
      recipient: fax_recipient.name,
    )
    snap_application.update(faxed_at: Time.zone.now)
  ensure
    snap_application.pdf.try(:close)
    snap_application.pdf.try(:unlink)
  end

  private

  attr_reader :snap_application

  def fax_recipient
    @fax_recipient ||=
      FaxRecipient.new(residential_address:
                         snap_application.residential_address)
  end
end
