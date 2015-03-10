class Views::LoggedOut::Index < Views::Base
  def content
    row(class: %i[fullWidth background-cover]) {
      column {
        row {
          column(:'medium-8', class: :'medium-offset-2') {
            br
            div(class: %i[clear-panel text-center]) {
              h1 {
                span "Slogan", class: :'text-primary'
                br
                span "Tagline", class: :'text-alert'
              }
              h4 "Solution X for Problem Y"

              p "Why this is right for you. " * 8

              div(class: buttonish(:large, :alert)) {
                text "Take Action"
              }
            }
          }
        }
      }
    }
  end
end
