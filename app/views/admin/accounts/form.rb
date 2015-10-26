class Views::Admin::Accounts::Form < Views::Base
  needs :account
  needs :roles

  def content
    form_for([:admin, account]) do |f|
      with_errors(account, :email) {
        label {
          text "E-mail: "
          f.text_field :email
        }
      }

      if account.new_record?
        with_errors(account, :password) {
          label {
            text "Password: "
            f.password_field :password
          }
        }
      end

      full_row {
        label("Roles: ")
        f.collection_check_boxes :role_ids, roles, :id, :name
      }

      div(class: "actions") {
        f.submit class: buttonish
      }
    end
  end
end
