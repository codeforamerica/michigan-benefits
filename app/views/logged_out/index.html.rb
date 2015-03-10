class Views::LoggedOut::Index < Views::Base
  def content
    full_row {
      h1("LoggedOut#index")
      p("Find me in app/views/logged_out/index.html.erb")
    }
  end
end
