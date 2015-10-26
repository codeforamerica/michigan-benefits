class Views::Admin::Metrics::DailyCountRows < Views::Base
  needs :metrics

  def content
    max_count = metrics.map { |signup| signup[:count] }.max
    metrics.each do |signup|
      tr {
        td(width: "200") {
          text(time_ago_in_words signup[:start])
          text " ago"
        }

        td(signup[:start].to_s(:weekday), width: "200")
        td(signup[:count], class: "text-right", width: "100")
        td(width: "300") {
          div(class: "progress") {
            span(class: "meter", style: "width: #{signup[:count].to_f / max_count  * 100}%")
          }
        }
      }
    end
  end
end
