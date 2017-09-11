class FaxApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |snap_application|
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
