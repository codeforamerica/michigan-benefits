class FaxApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |snap_application, logger|
      receiving_office = snap_application.receiving_office

      Fax.send_fax(
        number: receiving_office.fax_number,
        file: snap_application.pdf.path,
        recipient: receiving_office.name,
      )

      logger.info("Faxed to #{receiving_office.name} " \
                  "(#{receiving_office.fax_number})")
    end
  end
end
