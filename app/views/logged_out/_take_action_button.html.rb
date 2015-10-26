class Views::LoggedOut::TakeActionButton < Views::Base
  def content
    a(href: take_action_path) {
      div(class: buttonish(:large, :alert, 'take-action'), onclick: "analytics.track('acquisition/no-abandon')") {
        text "Take Action"
      }
    }
  end
end
