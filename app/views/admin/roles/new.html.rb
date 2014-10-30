class Views::Admin::Roles::New < Views::Base
  def content
    h1("New role")

    render 'form'

    link_to 'Back', admin_roles_path
  end
end
