class Views::Admin::Accounts::Form < Views::Base
  needs :account => nil
  needs :roles => nil

  def content
    text(form_for([:admin, account]) do |f|

      if account.errors.any?
        div(:id => "error_explanation") {
          h2 {
            text(pluralize(account.errors.count, "error"))
            text " prohibited this account from being saved:"
          }


          ul {
            account.errors.full_messages.each do |message|
              li(message)
            end
          }
        }
      end

      div(:class => "") {
        label {
          text "E-mail: "
          text(f.text_field :email)
        }
      }


      if account.new_record?
        div(:class => "") {
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
text " "
              text(role.name)
            }
          }
        end
      }


      div(:class => "actions") {
        text(f.submit)
      }
    end)
  end
end
