module Views
  module PasswordResets
    class New < Base
      def content
        row {
          column('medium-6', class: 'medium-centered') {
            h2("Forgot your password?")
            form_tag password_resets_path, method: :post do
              label {
                text "Email "
                text_field_tag :email
              }
              submit_tag "Reset my password!", class: buttonish(:small, :expand)
            end
          }
        }
      end
    end
  end
end
