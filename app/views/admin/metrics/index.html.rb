require 'metrics'

class Views::Admin::Metrics::Index < Views::Base
  def content
    full_row {
      h1("Metrics")

      h4("Empathy")
      h4("I've figured out how to solve a problem in a way my target market will adopt and pay for.", class: "subheader")

      p("One measure of empathy is whether new users are signing up for the site.")

      figure {
        figcaption("Sign-ups per day")
        table(role: "grid") {
          thead {
            tr {
              th("Signed up", colspan: "2")
              th("Users", colspan: "2")
            }
          }

          render partial: "daily_count_rows", locals: { metrics: Metrics.signups_per_day }
        }
      }


      figure {
        figcaption("Sign-ups per week")
        table(role: "grid") {
          thead {
            tr {
              th("Signed up", colspan: "2")
              th("Users", colspan: "2")
            }
          }

          render partial: "daily_count_rows", locals: { metrics: Metrics.signups_per_week }
        }
      }

      h4("Stickiness")
      h4("I've built the right features that keep users around.", class: "subheader")

      p("One measure of stickiness is how often users come back to the site. We don't have that information, but we know when they were last active on the site.")

      figure {
        figcaption("Churn per day")
        table(role: "grid") {
          thead {
            tr {
              th("Last Active", colspan: "2")
              th("Users", colspan: "2")
            }
          }

          render partial: "daily_count_rows", locals: { metrics: Metrics.churn_per_day }
        }
      }

      figure {
        figcaption("Churn per week")
        table(role: "grid") {
          thead {
            tr {
              th("Last Active", colspan: "2")
              th("Users", colspan: "2")
            }
          }

          render partial: "daily_count_rows", locals: { metrics: Metrics.churn_per_week }

          tr {
            td("Lapsed", colspan: "2")
            td(Metrics.lapsed[:count], class: "text-right")
            td
          }
        }
      }
    }
  end
end
