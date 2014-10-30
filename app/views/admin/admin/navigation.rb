class Views::Admin::Admin::Navigation < Views::Base
  def content
    section(:class => "top-bar-section") {
      # Right Nav Section

      ul(:class => "right") {
        li(:class => "active") {
          a("Right Button Active", :href => "#")
        }

        li(:class => "has-dropdown") {
          a("Right Button Dropdown", :href => "#")
          ul(:class => "dropdown") {
            li {
              a("First link in dropdown", :href => "#")
            }

            li(:class => "active") {
              a("Active link in dropdown", :href => "#")
            }
          }
        }
      }


      # Left Nav Section

      ul(:class => "left") {
        li {
          a("Left Nav Button", :href => "#")
        }
      }
    }
  end
end
