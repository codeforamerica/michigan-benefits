class Views::Steps::Show < Views::Base
  needs :step

  def content
    content_for :template_name, "step"

    menu_header
    step_form
  end

  private

  def menu_header
    div class: 'step-header' do
      h4 class: 'step-header__title' do
        text step.title
        if Rails.env.development?
          code " (#{step.class.name})", style: "opacity: 0.5"
        end
      end
    end
  end

  def section_header
    div class: 'step-section-header' do
      if step.icon.present?
        div class: [
          "step-section-header__icon",
          "illustration",
          "illustration--#{step.icon}"
        ]
      end

      h4 step.headline, class: "step-section-header__headline"
      h3 step.subhead, class: "step-section-header__subhead"
    end
  end

  def step_form
    form_for step, as: :step, url: step_path(step), method: :put do |f|
      div class: 'form-card' do
        header class: 'form-card__header' do
          section_header
        end

        div class: 'form-card__content' do
          step.questions.each do |question, label_text|
            group_classes = 'form-group'

            if step.errors[question].present?
              group_classes += ' form-group--error'
            end

            field_type = step.type(question)

            div class: group_classes, 'data-field-type' => field_type do
              f.label question, label_text, class: 'form-question'

              case field_type
              when :text
                f.text_field question,
                  placeholder: step.placeholder(question),
                  class: 'text-input'
              when :yes_no
                div do
                  label class: "radio-button" do
                    f.radio_button question, "true"
                    text "Yes"
                  end

                  label class: "radio-button" do
                    f.radio_button question, "false"
                    text "No"
                  end
                end
              else
                raise "Unknown field type #{field_type}"
              end

              if step.errors[question].present?
                p class: 'text--error' do
                  i class: 'icon-warning'
                  text step.errors[question].to_sentence
                end
              end
            end
          end
        end

        footer class: 'form-card__footer' do
          if step.previous.present?
            link_to "Go back", step_path(step.previous), class: "button button--transparent"
          end

          button type: 'submit', class: "button button--cta" do
            text "Continue"
            i class: "button__icon icon-arrow_forward"
          end
        end
      end
    end
  end
end
