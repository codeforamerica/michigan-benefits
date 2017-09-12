class ApplicationSubmittedSmsJob < ApplicationJob
  def perform(snap_application:)
    Sms.new(snap_application).deliver_application_submitted_message
  end
end
