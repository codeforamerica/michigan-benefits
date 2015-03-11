class Views::LoggedOut::TakeActionButton < Views::Base
  def content
    div(class: buttonish(:large, :alert), onclick: "analytics.track('acquisition/no-abandon')") {
      a(href: take_action_path) {
        text "Take Action"
      }
    }
  end
end