class Views::Steps::Show < Views::Base
  needs :step

  def content
    h1 step.title, class: "title"
    h2 step.headline, class: "headline"
    h3 step.subhead, class: "subhead"

    form_for step, url: step_path(step), method: :put do |f|
      step.questions.each do |question, label_text|
        field_name = "step[#{question}]"
        field_type = step.type(question)

        label label_text, "data-field-type" => field_type do
          if step.errors[question].present?
            text step.errors[question].to_sentence
          end

          case field_type
            when :text
              f.text_field question, name: field_name, placeholder: step.placeholder(question)
            when :yes_no
              div do
                label do
                  f.radio_button question, "true", name: field_name
                  text "Yes"
                end
                label do
                  f.radio_button question, "false", name: field_name
                  text "No"
                end
              end
            else
              raise "Unknown field type #{field_type}"
          end
        end
      end

      link_to "Go back", step_path(step.previous) if step.previous.present?
      f.submit "Continue"
    end
  end
end
