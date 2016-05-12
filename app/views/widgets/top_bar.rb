class Views::Widgets::TopBar < Views::Base
  # http://foundation.zurb.com/sites/docs/top-bar.html

  needs :title

  def content
    div class: "top-bar" do
      div class: "top-bar-left" do
        ul class: "dropdown menu", "data-dropdown-menu" => "" do
          li title, class: "menu-text"
        end
      end

      div class: "top-bar-right" do
        ul class: "menu" do
          if logged_in?
            li current_user.name, class: "logged-in-as"
          else
            li do
              link_to "Sign Up", new_user_path, class: "button"
            end
          end
        end
      end
    end
  end
end
