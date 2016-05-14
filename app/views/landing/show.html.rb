class Views::Landing::Show < Views::Base
  def content
    row do
      columns do
        h1 "Welcome to #{Rails.application.config.site_name}!"

        p "Perhaps you'd like to sign up or log in?"
      end
    end
  end
end
