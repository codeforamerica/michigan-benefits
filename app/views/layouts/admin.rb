class Views::Layouts::Admin < Views::Base
  def content
    if !content_for?(:app_navigation)
      content_for :app_navigation do
        render partial: 'shared/admin/side_nav'
      end
    end
    render template: 'layouts/logged_in'
  end
end
