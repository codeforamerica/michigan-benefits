class Views::Steps::Show < Views::Base
  needs :step

  def content
    content_for :template_name, "step"

    menu_header
    step_form

    render partial: "shared/footer"
  end

  private

  def render_static_content?
    step.static_template.present?
  end

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

  def step_form
    div class: 'form-card' do
      form_for step, as: :step, url: step_path(step), method: :put do |f|
        header class: 'form-card__header' do
          section_header
        end

        if render_static_content?
          div class: 'form-card__content' do
            render step.static_template
          end
        else
          div class: 'form-card__content' do
            questions(f)
          end
        end

        footer class: 'form-card__footer' do
          buttons
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

  def questions(f)
    step.questions.each do |question, label_text|
      group_classes = 'form-group'

      if step.errors[question].present?
        group_classes += ' form-group--error'
      end

      field_type = step.type(question)

      div class: group_classes, 'data-field-type' => field_type do
        if step.section_header(question)
          h4 step.section_header(question), class: "form-group__headline"
        end

        case field_type
          when :text
            f.label question, label_text, class: 'form-question'

            f.text_field question,
              placeholder: step.placeholder(question),
              class: 'text-input'
          when :yes_no
            f.label question, label_text, class: 'form-question'

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
          when :checkbox
            label class: "checkbox" do
              f.check_box question
              text label_text
            end
          else
            raise "Unknown field type #{field_type}"
        end

        if step.errors[question].present?
          p class: 'text--error' do
            i class: 'icon-warning'
            text " #{step.errors[question].to_sentence}"
          end
        end
      end
    end
  end

  def buttons
    if step.previous.present?
      link_to "Go back", path_to_step(step.previous), class: "button button--transparent"
    end

    button type: 'submit', class: "button button--cta" do
      text "Continue"
      i class: "button__icon icon-arrow_forward"
    end
  end
end
