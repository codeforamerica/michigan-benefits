class Views::Shared::Navigation < Views::Base
  def content
    section(class: "top-bar-section") {
      # Right Nav Section

      ul(class: "right") {
        li(class: "has-dropdown") {
          a {
            i(class: "fi-torso")
            text "Account"
          }
          ul(class: "dropdown") {
            if logged_in?
              if policy(:application).admin?
                li { link_to 'Admin', admin_path }
              end

              li {
                link_to 'Profile', edit_account_path(current_user)
              }

              li {
                link_to 'Log out', session_path, method: :delete
              }
            end
          }
        }
      }
    }
  end
end
