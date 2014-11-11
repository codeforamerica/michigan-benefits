require Rails.root.join('spec/support/mom')

# Preview all emails at http://localhost:3000/rails/mailers/accounts_mailer
class AccountsMailerPreview < ActionMailer::Preview
  def reset_password
    account = an_account
    account.deliver_reset_password_instructions!
    AccountsMailer.reset_password_email(account)
  end

  private

  def an_account
    Account.last || create(:account)
  end
end
