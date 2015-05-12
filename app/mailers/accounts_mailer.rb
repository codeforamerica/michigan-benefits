class AccountsMailer < ActionMailer::Base
  default from: Rails.application.config.contact_email
  layout "email"

  def reset_password_email(account)
    @account = account
    @url = edit_password_reset_url(account.reset_password_token)
    mail(to: account.email, subject: "Change your #{Rails.application.config.project_name} password")
  end
end
