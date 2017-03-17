class Views::Steps::Show < Views::Base
  needs :step

  def content
    h1 step.title, class: "title"
    h2 step.headline, class: "headline"
    h3 step.subhead, class: "subhead"

    form_tag(request.path, method: :put) do
      step.questions.each do |question|
        label question.title, "data-question-type" => question.type do
          name = "step[#{question.name}]"
          case question.type
            when :text
              text text_field_tag(name, "", placeholder: question.placeholder)
            when :yes_no
              label "Yes" do
                text radio_button_tag(name, "true")
              end
              label "No" do
                text radio_button_tag(name, "false")
              end
            else
              raise "Unknown question type: #{question.type}"
          end
        end
      end

      submit_tag "Continue"
    end
  end
end
