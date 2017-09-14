class FaxApplicationJob < ApplicationJob
  def perform(export:)
    export.execute do |snap_application|
      receiving_office = snap_application.receiving_office

      Fax.send_fax(
        number: receiving_office.number,
        file: snap_application.pdf.path,
        recipient: receiving_office.name,
      )

      "Faxed to #{receiving_office.name} (#{receiving_office.number})"
    end
  end
end
