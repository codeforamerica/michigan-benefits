class Views::Admin::Roles::Form < Views::Base
  needs :role

  def content
    form_for([:admin, role]) do |f|
      if role.errors.any?
        div(:id => "error_explanation") {
          h2 {
            text(pluralize(role.errors.count, "error"))
            text " prohibited this role from being saved:"
          }

          ul {
            role.errors.full_messages.each do |message|
              li(message)
            end
          }
        }
      end

      div {
        label {
          text "Name: "
          text(f.text_field :name)
        }
      }

      div {
        label {
          text "Key: "
          text(f.text_field :key)
        }
      }

      div(:class => "actions") {
        text(f.submit)
      }
    end
  end
end
