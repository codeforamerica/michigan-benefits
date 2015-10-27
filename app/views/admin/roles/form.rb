class Views::Admin::Roles::Form < Views::Base
  needs :role

  def content
    form_for([:admin, role]) do |f|
      with_errors(role, :name) {
        label {
          text "Name: "
          f.text_field :name
        }
      }

      with_errors(role, :key) {
        label {
          text "Key: "
          f.text_field :key
        }
      }

      div(class: "actions") {
        f.submit class: buttonish
      }
    end
  end
end
