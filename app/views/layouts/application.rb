class Views::Layouts::Application < Views::Base
  def content
    content_for :body do
      div(:class => "app-container", "data-equalizer" => "") {
        div(:class => "app-nav", "data-equalizer-watch" => "") {
          yield :app_navigation
        }


        if content_for?(:app_aside)
          div(:class => "app-content", "data-equalizer-watch" => "") {
            yield
          }

          div(:class => "app-aside", "data-equalizer-watch" => "") {
            yield :app_aside
          }
        else
          div(:class => "app-content-wide", "data-equalizer-watch" => "") {
            yield
          }
        end
      }
    end

    render template: "layouts/raw"
  end
end
