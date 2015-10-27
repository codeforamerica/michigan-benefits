module Views
  module Accounts
    class Edit < Views::Base
      needs :account

      def content
        row {
          column('large-6') {
            h2("Account Profile")

            p {
              text "Email: "
              text account.email
            }

            h4("Change Password")

            form_for account do |f|
              with_errors(account, :old_password) {
                label {
                  text "Old Password "
                  f.password_field :old_password
                }
              }
              with_errors(account, :password) {
                label {
                  text "New Password "
                  f.password_field :password
                }
              }
              f.submit "Change", class: buttonish(:small, :expand)
            end
          }
        }
      end
    end
  end
end
