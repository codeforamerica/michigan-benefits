class Views::Admin::Roles::Edit < Views::Base
  needs :role => nil
  
  def content
    h1("Editing role")

    render 'form'
text " "
    link_to 'Show', admin_role_path(role)
    text " |"

    link_to 'Back', admin_roles_path
  end
end
