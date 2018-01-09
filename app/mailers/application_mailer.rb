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

  def office_snap_application_notification(
    file_name:,
    recipient_email:,
    applicant_name:,
    office_location: nil
  )
    attachments[attachment_name(applicant_name, "1171")] = File.read(file_name)
    @office_location = office_location

    mail(
      from: %("Michigan Benefits" <hello@#{ENV['EMAIL_DOMAIN']}>),
      to: recipient_email,
      subject: subject(office_location, applicant_name),
      template_name: template_name(office_location),
    )
  end

  def office_medicaid_application_notification(
    file_name:,
    recipient_email:,
    applicant_name:
  )
    attachments[attachment_name(applicant_name, "1426")] = File.read(file_name)

    mail(
      from: %("Michigan Benefits" <hello@#{ENV['EMAIL_DOMAIN']}>),
      to: recipient_email,
      subject: "A new 1426 from #{applicant_name} was submitted!",
      template_name: "office_medicaid_application_notification",
    )
  end

  private

  def subject(office_location, applicant_name)
    if office_location.present?
      "A new 1171 from #{applicant_name} (in the lobby) was submitted!"
    else
      "A new 1171 from #{applicant_name} (online) was submitted!"
    end
  end

  def template_name(office_location)
    if office_location.present?
      "in_office_snap_application_notification"
    else
      "office_snap_application_notification"
    end
  end

  def attachment_name(applicant_name, type)
    "#{formatted_date} #{applicant_name} #{type}.pdf"
  end

  def formatted_date
    TimeZoneHelper.date_in_est(DateTime.now).strftime("%Y-%m-%d")
  end
end
