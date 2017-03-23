class FormMailer < ApplicationMailer
  def submission(form:)
    attachments['application.pdf'] = File.read(form.fill)

    mail(
      to: ENV['FORM_RECIPIENT'],
      subject: "New submission attached"
    )
  end
end
