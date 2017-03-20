class Views::Widgets::TopBar < Views::Base
  # http://foundation.zurb.com/sites/docs/top-bar.html

  needs :title

  def content
    div class: "top-bar" do
      div class: "top-bar-left" do
        ul class: "menu" do
          li title, class: "menu-text"
        end
      end

      div class: "top-bar-right" do
        if logged_in?
          ul class: "menu align-right" do
            li do
              li current_user.full_name, class: "logged-in-as menu-text"
              li do
                link_to "Log Out", sessions_path, method: :delete
              end
            end
          end
        else
          ul class: "menu align-right" do
            li do
              link_to "Sign Up", new_user_path
            end

            li do
              link_to "Log In", new_sessions_path
            end
          end
        end
      end
    end
  end
end
