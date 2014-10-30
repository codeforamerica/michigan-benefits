class Views::Sessions::New < Views::Base
  def content
    row {
      div(:class => "small-12 large-6 large-centered columns") {
        h1("Log in")

        form_tag session_path, method: 'post' do
          row {
            div(:class => "large-12 columns") {
              label {
                text "E-mail: "
                text_field_tag :email
              }
              br
              label {
                text "Password: "
                password_field_tag :password
              }
              br
              submit_tag "Log In", :class=>'button primary medium'
            }
          }
        end
      }
    }
  end
end
