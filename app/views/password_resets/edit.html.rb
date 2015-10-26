module Views
  module PasswordResets
    class Edit < Views::Base
      needs :account
      needs :token

      def content
        # TODO: this is nearly identical to Views::AccountClaims::Edit. Definitely refactor if it's similar to change-password.
        row {
          column('medium-6', class: 'medium-centered') {
            h2("Set a password")
            form_for account, url: password_reset_path(token), html: { method: :put } do |f|
              row {
                column {
                  label {
                    text "Email "
                    f.text_field :email, disabled: true
                  }
                }
              }
              row {
                column {
                  with_errors(f.object, :password) {
                    label {
                      text "Password "
                      f.password_field :password
                    }
                  }
                }
              }
              row {
                column {
                  f.submit "Save", class: buttonish(:small, :expand)
                }
              }
            end
          }
        }
      end
    end
  end
end
