class Views::Layouts::Application < Views::Base
  def content
    html do
      head do
        meta content: "text/html; charset=UTF-8", "http-equiv" => "Content-Type"
        meta charset: "utf-8"
        meta content: "width=device-width, initial-scale=1.0", name: "viewport"
        meta content: Rails.application.config.project_description, name: "description"

        title(content_for?(:title) ? yield(:title) : Rails.application.config.site_name)

        csrf_meta_tags
        stylesheet_link_tag 'application', media: 'all'
        javascript_include_tag 'application'
      end

      body class: "#{controller_name.underscore.dasherize}-#{action_name.underscore.dasherize}" do
        # top_bar

        text yield
      end
    end
  end
end
