class Views::LoggedOut::Index < Views::Base
  def content
    wide_row('background-cover') {
      div(class: 'inner-background-cover') {
        h1 {
          span "Slogan", class: 'text-primary'
          br
          span "Tagline", class: 'text-alert'
        }
        h4 "Solution X for Problem Y"

        p "Why this is right for you. " * 8

        render partial: "take_action_button"
      }
    }
    wide_row('landing-quote') {
      blockquote {
        text "\"You have brains in your head. You have feet in your shoes. You can steer yourself in any direction you choose. You're on your own, and you know what you know. And you are the guy who'll decide where to go.\""
        cite "Dr. Seuss"
      }
    }
    wide_row('landing-description text-center') {
      h4 "About Product Z"
      p "We do this onne thing really well. Squid ennui cray trust fund fixie, forage Odd Future. Godard actually ennui, put a bird on it polaroid four loko meditation whatever swag food truck letterpress. Tilde Vice Tumblr, Helvetica quinoa meggings locavore. Vegan freegan disrupt synth mumblecore banjo slow-carb messenger bag paleo, Wes Anderson Echo Park."
      p "Click below to sign up for our service. Marfa synth beard Shoreditch mixtape, tousled messenger bag next level cronut. Salvia four dollar toast tofu, you probably haven't heard of them raw denim polaroid pork belly Shoreditch."
      render partial: "take_action_button"
    }
    javascript "analytics.track('acquisition/visit')"
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
