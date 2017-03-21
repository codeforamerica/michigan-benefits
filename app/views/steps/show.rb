class Views::Steps::Show < Views::Base
  needs :step

  def content
    content_for :template_name, "step"

    menu_header
    section_header
    step_form
  end

  private

  def menu_header
    div class: 'step-header' do
      div class: 'step-header__burger'

      h4 step.title, class: 'step-header__title'
    end
  end

  def section_header
    h2 step.headline, class: "headline"
    h3 step.subhead, class: "subhead"
  end

  def step_form
    form_for step, as: :step, url: step_path(step), method: :put do |f|
      step.questions.each do |question, label_text|
        field_type = step.type(question)

        label label_text, "data-field-type" => field_type do
          if step.errors[question].present?
            text step.errors[question].to_sentence
          end

          case field_type
          when :text
            f.text_field question, placeholder: step.placeholder(question)
          when :yes_no
            div do
              label do
                f.radio_button question, "true"
                text "Yes"
              end

              label do
                f.radio_button question, "false"
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
