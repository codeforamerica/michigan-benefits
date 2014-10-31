class Views::Sessions::New < Views::Base
  def content
    row {
      column(%i[small-12 large-6], :class => :"large-centered") {
        h1("Log in")

        form_tag session_path, method: 'post' do
          row {
            column(:"large-12") {
              label {
                text "E-mail: "
                text_field_tag :email
              }
              br
              label {
                text "Password: "
                link_to "Forgot?", new_password_reset_path
                password_field_tag :password
              }
              br
              submit_tag "Log In", class: %i[button primary medium]
            }
          }
        end
      }
    }
  end
end
