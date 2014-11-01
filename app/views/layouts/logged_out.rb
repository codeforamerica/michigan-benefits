class Views::Layouts::LoggedOut < Views::Base
  def content
    content_for :navigation do
      comment "no nav"
    end
    render template: 'layouts/raw'
  end
end
