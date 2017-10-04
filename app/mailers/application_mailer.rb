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

  def office_application_notification(
    file_name:,
    recipient_email:,
    office_location: nil
  )
    attachments["snap_application.pdf"] = File.read(file_name)
    @office_location = office_location

    mail(
      from: %("Michigan Benefits" <hello@#{ENV['EMAIL_DOMAIN']}>),
      to: recipient_email,
      subject: subject(office_location),
      template_name: template_name(office_location),
    )
  end

  private

  def subject(office_location)
    if office_location.present?
      "A new 1171 from someone in the lobby has been submitted!"
    else
      "A new 1171 from someone online has been submitted!"
    end
  end

  def template_name(office_location)
    if office_location.present?
      "in_office_application_notification"
    else
      "office_application_notification"
    end
  end
end
