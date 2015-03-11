class Views::LoggedOut::Index < Views::Base
  def content
    wide_row(:'background-cover') {
      div(class: %i[clear-panel text-center]) {
        h1 {
          span "Slogan", class: :'text-primary'
          br
          span "Tagline", class: :'text-alert'
        }
        h4 "Solution X for Problem Y"

        p "Why this is right for you. " * 8

        div(class: buttonish(:large, :alert), onclick: "analytics.track('acquisition/no-abandon')") {
          text "Take Action"
        }
      }
    }
    wide_row(:'palate-white-on-green') {
      blockquote(class: :'blockquote-grande') {
        text "“It's really good”"
        cite "First User"
      }
    }
    javascript "analytics.track('acquisition/visit')"
  end

  private

  def wide_row(add_class)
    classes = [:fullWidth]
    classes << add_class
    row(class: classes) {
      column {
        row {
          column(:'medium-8', class: :'medium-offset-2') {
            br
            yield
          }
        }
      }
    }
  end
end
