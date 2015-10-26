class Views::Layouts::LoggedIn < Views::Base
  def content
    content_for :navigation do
      render partial: 'shared/navigation'
    end

    content_for :body do
      div(class: "app-container") {
        div(class: "app-nav") {
          yield :app_navigation
        }


        if content_for?(:app_aside)
          div(class: "app-content") { yield }

          div(class: "app-aside") { yield :app_aside }
        else
          div(class: "app-content-wide") { yield }
        end
      }
    end

    render template: "layouts/raw"
  end
end
