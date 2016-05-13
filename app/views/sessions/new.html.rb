class Views::Sessions::New < Views::Base
  def content
    basic_form_for :session, { url: sessions_path }, title: "Log In" do |f|
      f.field :email, type: :email, title: "Email Address"
      f.field :password, type: :password
    end
  end
end
