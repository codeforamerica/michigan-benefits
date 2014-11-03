class Views::Admin::Accounts::Show < Views::Base
  needs :account

  def content
    full_row {
      p {
        text "E-mail: "
        text(account.email)
      }
      p {
        text "Roles: "
        text(account.roles.map(&:name).join(', '))
      }
      p {
        link_to 'Edit', edit_admin_account_path(account)
        text " | "
        link_to 'Back', admin_accounts_path
      }
    }
  end
end
