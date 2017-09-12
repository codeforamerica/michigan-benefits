class ApplicationSubmittedSmsJob < ApplicationJob
  def perform(export:)
    export.execute do |snap_application|
      Sms.new(snap_application).deliver_application_submitted_message

      "Sent SMS to #{snap_application.phone_number}"
    end
  end
end
