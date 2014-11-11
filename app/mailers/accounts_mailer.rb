class AccountsMailer < ActionMailer::Base
  default from: "citizen-code@example.com"
  layout "email"

  def reset_password_email(account)
    @account = account
    @url = edit_password_reset_url(account.reset_password_token)
    mail(to: account.email, subject: "Change your Citizen Code password")
  end
end
