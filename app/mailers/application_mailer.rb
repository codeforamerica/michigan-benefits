# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "hello@#{ENV['EMAIL_DOMAIN']}"
  layout "mailer"

  def snap_application_notification(file_name:, recipient_email:)
    attachments["snap_application.pdf"] = File.read(file_name)
    mail to: recipient_email, subject: "Your SNAP application"
  end

  def office_application_notification(file_name:, recipient_email:)
    attachments["snap_application.pdf"] = File.read(file_name)
    mail to: recipient_email, subject: "Newly submitted SNAP application"
  end
end
