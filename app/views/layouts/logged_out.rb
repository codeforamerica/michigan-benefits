class Views::Layouts::LoggedOut < Views::Base
  def content
    render template: 'layouts/raw'
  end
end
