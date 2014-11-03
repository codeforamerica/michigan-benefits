class Views::Layouts::LoggedOut < Views::Base
  def content
    # content_for :footer do
    # end
    render template: 'layouts/raw'
  end
end
