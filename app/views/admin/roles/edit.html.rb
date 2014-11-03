class Views::Admin::Roles::Edit < Views::Base
  needs :role

  def content
    full_row {
      h1("Editing role")

      render 'form'

      link_to 'Show', admin_role_path(role)
      text " | "
      link_to 'Back', admin_roles_path
    }
  end
end
