class Views::LoggedOut::ActivationButton < Views::Base
  def content
    a(href: "#") {
      div(class: buttonish(:large, :alert, :bordered), onclick: "analytics.track('activation/signup')") {
        text "Activate"
      }
    }
  end
end
