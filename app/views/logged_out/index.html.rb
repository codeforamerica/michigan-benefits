class Views::LoggedOut::Index < Views::Base
  def content
    div(:class => "small-12 large-12 columns") {
      h1("LoggedOut#index")
      p("Find me in app/views/logged_out/index.html.erb")
      p("Testing button styles and colors below...")
      row {
        div(:class => "small-12 large-6 columns") {
          link_to 'Sign Up', new_account_path, :class=>'button medium radius primary expand'
        }

        div(:class => "small-12 large-6 columns") {
          link_to 'Log in', new_session_path, :class=>'button medium radius success expand'
        }
      }
    }
  end
end
