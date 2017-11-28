class FaxApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |benefit_application, logger|
      receiving_office = benefit_application.receiving_office

      Fax.send_fax(
        number: receiving_office.fax_number,
        file: benefit_application.pdf.path,
        recipient: receiving_office.name,
      )

      logger.info("Faxed to #{receiving_office.name} " \
                  "(#{receiving_office.fax_number})")
    end
  end
end
