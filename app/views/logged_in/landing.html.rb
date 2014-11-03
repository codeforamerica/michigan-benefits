class Views::LoggedIn::Landing < Views::Base
  def content
    full_row {
      h1("LoggedIn#landing")
      p("Find me in app/views/logged_in/landing.html.erb!!")
    }
  end
end
