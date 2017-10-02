# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  layout "mailer"

  def snap_application_notification(file_name:, recipient_email:)
    attachments["snap_application.pdf"] = File.read(file_name)
    mail(
      from: %("Michigan Benefits" <hello@#{ENV['EMAIL_DOMAIN']}>),
      to: recipient_email,
      subject: "Your SNAP application",
    )
  end

  def office_application_notification(file_name:, recipient_email:)
    attachments["snap_application.pdf"] = File.read(file_name)
    mail(
      from: %("Michigan Benefits" <hello@#{ENV['EMAIL_DOMAIN']}>),
      to: recipient_email,
      subject: "A new 1171 from the Digital Assister has been submitted!",
    )
  end
end
