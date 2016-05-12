class Views::Users::New < Views::Base
  needs :user

  def content
    basic_form_for user, title: "Sign Up" do |f|
      f.field :name
      f.field :email, type: :email, title: "Email Address"
      f.field :password, type: :password
    end
  end
end
