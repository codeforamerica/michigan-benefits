class ApplicationSubmittedSmsJob < ApplicationJob
  def perform(export:)
    export.execute do |benefit_application|
      Sms.new(benefit_application).deliver_application_submitted_message

      logger.info("Sent SMS to #{benefit_application.phone_number}")
    end
  end
end
