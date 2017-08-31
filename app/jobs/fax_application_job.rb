class FaxApplicationJob < ApplicationJob
  def perform(export_id:)
    export = Export.find(export_id)
    export.execute do |snap_application|
      return if snap_application.faxed?

      fax_recipient = FaxRecipient.new(residential_address:
                                       snap_application.residential_address)
      Fax.send_fax(
        number: fax_recipient.number,
        file: snap_application.pdf.path,
        recipient: fax_recipient.name,
      )

      "Faxed to #{fax_recipient.name} (#{fax_recipient.number})"
    end
  end
end
