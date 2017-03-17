class Views::Users::New < Views::Base
  needs :user

  def content
    h1 "Get the support your family needs"

    basic_form_for user, title: nil, submit: "Apply Now" do |f|
    end
  end
end
