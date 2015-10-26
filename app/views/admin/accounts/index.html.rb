class Views::Admin::Accounts::Index < Views::Base
  needs :accounts

  def content
    full_row {
      h1("Listing accounts")

      p {
        text "Found "
        text(accounts.length)
        text " accounts."
      }
      table {
        thead {
          tr {
            th("E-mail")
            th("Roles")
            th(colspan: "3")
          }
        }


        tbody {
          accounts.each do |account|
            tr {
              td(account.email)
              td(account.roles.map(&:name).join(', '))
              td {
                link_to 'Show', admin_account_path(account)
              }

              td {
                link_to 'Edit', edit_admin_account_path(account)
              }

              td {
                link_to 'Destroy', admin_account_path(account), method: :delete, data: { confirm: 'Are you sure?' }
              }
            }
          end
        }
      }


      p {
        link_to 'New Account', new_admin_account_path, class: buttonish
      }
      p {
        link_to 'Back', admin_path
      }
    }
  end
end
