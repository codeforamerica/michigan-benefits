class Views::LoggedIn::Landing < Views::Base
  def content
    h1("LoggedIn#landing")
    p("Find me in app/views/logged_in/landing.html.erb!!")

    p {
      link_to 'Admin', admin_path
    }
    p {
      link_to 'Log out', session_path, method: :delete
    }
  end
end
