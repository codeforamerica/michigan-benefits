class Views::Admin::Roles::Index < Views::Base
  needs :roles

  def content
    full_row {
      h1("Listing roles")

      table {
        thead {
          tr {
            th("Name")
            th("Key")
            th(colspan: "3")
          }
        }

        tbody {
          roles.each do |role|
            tr {
              td(role.name)
              td(role.key)
              td { link_to 'Show', admin_role_path(role) }
              td { link_to 'Edit', edit_admin_role_path(role) }
              td { link_to 'Destroy', admin_role_path(role), method: :delete, data: { confirm: 'Are you sure?' } }
            }
          end
        }
      }

      p {
        link_to 'New Role', new_admin_role_path, class: buttonish
      }
      p {
        link_to 'Back', admin_path
      }
    }
  end
end
