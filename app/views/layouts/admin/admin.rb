class Views::Layouts::Admin::Admin < Views::Base
  def content
    content_for :navigation do
      render partial: 'admin/admin/navigation'
    end
    if !content_for?(:app_navigation)
      content_for :app_navigation do
        render partial: 'admin/admin/side_nav'
      end
    end
    render template: 'layouts/application'
  end
end
