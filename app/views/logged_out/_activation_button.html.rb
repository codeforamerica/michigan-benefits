class Views::LoggedOut::ActivationButton < Views::Base
  def content
    div(class: buttonish(:large, :alert, :bordered), onclick: "analytics.track('activation/signup')") {
      a(href: "#") {
        text "Activate"
      }
    }
  end
end