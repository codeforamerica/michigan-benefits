class Views::Admin::Accounts::Form < Views::Base
  needs :account
  needs :roles

  def content
    form_for([:admin, account]) do |f|
      with_errors(account, :email) {
        label {
          text "E-mail: "
          text(f.text_field :email)
        }
      }

      if account.new_record?
        with_errors(account, :password) {
          label {
            text "Password: "
            text(f.password_field :password)
          }
        }
      end

      label("Roles:")
      ul {
        roles.each do |role|
          li {
            label {
              check_box_tag "account[roles][]", role.id, account.roles.include?(role)
              text(role.name)
            }
          }
        end
      }

      div(:class => "actions") {
        text(f.submit class: buttonish)
      }
    end
  end
end
