class Views::Admin::Admin::Index < Views::Base
  def content
    content_for :app_aside do
      p("I'm on the right side!")
    end

    full_row {
      h1("Admin::Admin#index")
      p("Find me in app/views/admin/admin/index.html.erb")
    }
  end
end
