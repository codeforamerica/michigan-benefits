class Views::LoggedOut::Index < Views::Base
  def content
    column(%i[small-12 large-12]) {
      h1("LoggedOut#index")
      p("Find me in app/views/logged_out/index.html.erb")
      p("Testing button styles and colors below...")
      row {
        column(%i[small-12 large-6]) {
          link_to 'Sign Up', new_account_path, class: %i[button medium radius primary expand]
        }

        column(%i[small-12 large-6]) {
          link_to 'Log in', new_session_path, class: %i[button medium radius success expand]
        }
      }
    }
  end
end
