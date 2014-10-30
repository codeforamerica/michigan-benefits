class Views::Layouts::Raw < Views::Base
  def content
    doctype!
    html(:lang => "en") {
      head {
        meta(:content => "text/html; charset=UTF-8", "http-equiv" => "Content-Type")
        meta(:charset => "utf-8")
        meta(:content => "width=device-width, initial-scale=1.0", :name => "viewport")

        title(content_for?(:title) ? yield(:title) : "CitizenRails")

        stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true
        stylesheet_link_tag    '//fonts.googleapis.com/css?family=Muli'
        javascript_include_tag 'vendor/modernizr'
        javascript_include_tag 'application', 'data-turbolinks-track' => true
        csrf_meta_tags
      }


      body {
        nav(:class => "top-bar", "data-topbar" => "", :role => "navigation") {
          ul(:class => "title-area") {
            li(:class => "name") {
              h1 {
                a("Citizen Code", :href => "/")
              }
            }

            li(:class => "toggle-topbar menu-icon") {
              a(:href => "#") {
                span("Menu")
              }
            }
          }


          yield :navigation
        }


        flash.each do |name, msg|
          div("aria-labelledby" => "flash-msg-#{name}", "aria-role" => "dialog", :class => "alert-box flash-msg #{name}", "data-alert" => "") {
            div(msg, :id => "flash-msg-#{name}")
            a("×", :class => "close", :href => "#")
          }
        end

        content_for?(:body) ? yield(:body) : yield
      }
    }
  end
end
