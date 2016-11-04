class Views::Layouts::Application < Views::Base
  def content
    html lang: "en" do
      head do
        meta content: "text/html; charset=UTF-8", "http-equiv" => "Content-Type"
        meta charset: "utf-8"
        meta content: "width=device-width, initial-scale=1.0", name: "viewport"
        meta content: Rails.application.config.project_description, name: "description"

        title(content_for?(:title) ? yield(:title) : Rails.application.config.site_name)

        csrf_meta_tags
        stylesheet_link_tag 'application', media: 'all'
        javascript_include_tag 'application'
        font = 'Open Sans' # go to https://fonts.google.com/ for more free fonts!
        link rel: "stylesheet", type: "text/css", href: "http://fonts.googleapis.com/css?family=#{font}"
        style do
          text(<<~STYLE.html_safe)
                body, h1, h2, h3, h4, p { font-family: '#{font}', serif; }
          STYLE
        end
      end

      body class: "#{controller_name.underscore.dasherize}-#{action_name.underscore.dasherize}" do
        top_bar title: Rails.application.config.site_name

        flash.each do |name, msg|
          div msg, "aria-labelledby" => "flash-msg-#{name}", "aria-role" => "dialog", class: ['callout', 'flash', name]
        end

        div style: "height: 3rem"

        div class: %i[container] do
          yield
        end
      end
    end
  end
end
