class Views::LoggedOut::TakeAction < Views::Base
  def content
    wide_row('background-cover') {
      form(class: 'take-action-form') {

        div(class: 'take-action-background') {
          h4 "Take Action"
          p "Answering a few questions will help us decide whether to get in touch with you!"
          div(class: "row") {
            div(class: "medium-6 columns") {
              label {
                text "First Name"
                input(type: "text", placeholder: "First Name")
              }
            }
            div(class: "medium-6 columns") {
              label {
                text "Last Name"
                input(type: "text", placeholder: "Last Name")
              }
            }
          }
          div(class: "row") {
            div(class: "medium-12 columns") {
              label {
                text "Email"
                input(type: "text", placeholder: "you@example.com")
              }
            }
          }
          p "This information will not be shared"
        }
        div(class: "text-center") {
          br
          render partial: "activation_button"
        }
        p(class: "notice"){
         text "After you create your profile you will be contacted by a concierge to setup your first event!"
        }
      }
    }

  end

  private

  def wide_row(add_class)
    classes = ['full-width']
    classes << add_class
    row(class: classes) {
      column {
        row {
          column('medium-8', class: 'medium-offset-2') {
            br
            yield
          }
        }
      }
    }
  end
end
