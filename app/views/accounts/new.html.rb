class Views::Accounts::New < Views::Base
  needs :account

  def content
    row {
      column(%i[small-12 large-6], class: "large-centered") {
        h1("Signup")

        form_for account do |f|
          row {
            div(:class => "large-12 columns #{"error" if f.object.errors[:email].any?}") {
              label {
                text "E-mail: "
                text(f.text_field :email)
              }

              if f.object.errors[:email].any?
                small(f.object.errors[:email].to_sentence, :class => "error")
              end
            }

            div(:class => "large-12 columns #{"error" if f.object.errors[:password].any?}") {
              label {
                text "Password: "
                text(f.password_field :password)
              }

              if f.object.errors[:password].any?
                small(f.object.errors[:password].to_sentence, :class => "error")
              end
            }

            div(:class => "large-12 columns") {
              text(f.submit :class=>'button primary medium')
            }
          }
        end
      }
    }
  end
end
