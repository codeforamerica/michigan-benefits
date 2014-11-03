class Views::Admin::Accounts::Edit < Views::Base
  needs :account

  def content
    full_row {
      h1("Editing account")

      render 'form'

      link_to 'Show', admin_account_path(account)
      text " | "
      link_to 'Back', admin_accounts_path
    }
  end
end
