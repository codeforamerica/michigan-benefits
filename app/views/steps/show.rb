class Views::Steps::Show < Views::Base
  needs :step

  def content
    content_for :header_title, header_title
    content_for :back_path, back_path

    step_form
  end

  private

  def back_path
    if step.previous.present?
      path_to_step(step.previous)
    end
  end

  def header_title
    title = step.title

    if Rails.env.development?
      title += " <code style='opacity: 0.5'>(#{step.class.name}, app #{current_user.app.id})</code>"
    end

    title.html_safe
  end

  def render_static_content?
    step.static_template.present?
  end

  def step_form
    div class: 'form-card' do
      form_for step, as: :step, url: step_path(step), method: :put do |f|

        if step.params
          step.params.each do |k, v|
            hidden_field_tag k, v
          end
        end

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

        if step.previous.present? or step.next.present?
          footer class: 'form-card__footer' do
            buttons
          end
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

      subhead_classes = "step-section-header__subhead"

      if step.only_subhead?
        subhead_classes += " step-section-header__subhead--standalone"
      end

      h4 step.headline, class: "step-section-header__headline"
      h3 step.subhead, class: subhead_classes

      if step.subhead_help
        p step.subhead_help,
          class: 'text--help step-section-header__subhead-help'
      end
    end
  end

  def questions(f)
    general_questions(f)
    member_questions(f)
  end

  def member_questions(f)
    step.member_questions.each do |question|
      group_classes = 'form-group'

      if step.errors[question].present?
        group_classes += ' form-group--error'
      end

      current_user.app.household_members.each do |member|
        div class: group_classes, 'data-field-type' => :radios do

          h4 member.first_name.titleize, class: "step-section-header__headline"

          f.fields_for "household_members[]", member, :hidden_field_id => true do |member_fields|
            step.options_for(question).each do |option|
              label class: "radio-button" do
                member_fields.radio_button question, option
                text option.to_s.humanize
              end
            end
          end
        end
      end
    end
  end

  def general_questions(f)
    step.questions.each do |question, (label_text, label_option)|
      group_classes = 'form-group'

      if step.errors[question].present?
        group_classes += ' form-group--error'
      end

      field_option = step.options_for(question)

      if field_option.present? && field_option.is_a?(Hash)
        group_classes += " #{field_option[:form_group_class]}"
      end

      field_type = step.type(question)

      div class: group_classes, 'data-field-type' => field_type do
        if step.section_header(question)
          h4 step.section_header(question), class: "form-group__headline"
        end

        if step.overview(question)
          p step.overview(question)
        end

        case field_type
          when :nested_checkbox
            question_label(f, question, label_text, label_option)
            current_user.app.household_members.each do |member|
              f.fields_for "household_members[]", member, :hidden_field_id => true do |member_fields|
                label class: "checkbox" do
                  member_fields.check_box question
                  text member.first_name.titleize
                end
              end
            end
          when :text
            question_label(f, question, label_text, label_option)

            f.text_field question,
                         placeholder: step.placeholder(question),
                         class: 'text-input'
          when :text_area
            question_label(f, question, label_text, label_option)

            f.text_area question,
                        placeholder: step.placeholder(question),
                        class: 'textarea'
          when :incrementer
            question_label(f, question, label_text, label_option)

            div class: "incrementer" do
              span "-", class: "incrementer__subtract"
              f.number_field question, {
                class: "text-input form-width--short",
                min: 1,
                max: 30
              }
              span "+", class: "incrementer__add"
            end
          when :select
            f.label question, label_text, class: 'form-question'

            div class: "select" do
              f.select question,
                       step.options_for(question).map(&:titleize),
                       { include_blank: "Choose one" },
                       { class: "select__element" }
            end
          when :radios
            question_label(f, question, label_text, label_option)

            div do
              step.options_for(question).each do |option|
                label class: "radio-button" do
                  f.radio_button question, option
                  text option.titleize
                end
              end
            end
          when :yes_no
            question_label(f, question, label_text, label_option)

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
          when :date
            f.label question,
                    label_text,
                    class: 'form-question',
                    id: "date-label-#{question}"

            div class: "input-group--inline" do
              div class: "select" do
                date_options = {
                  date_separator: '</div><div class="select">',
                  order: %i[month day year],
                  use_month_numbers: true,
                  start_year: Date.today.year - 130,
                  end_year: Date.today.year - 18,
                  prompt: true,
                  prefix: "step"
                }

                html_options = {
                  class: "select__element",
                  aria: { labelledby: "date-label-#{question}" }
                }

                date_select(f, question, date_options, html_options)
              end
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

  def question_label(f, question, label_text, label_option)
    f.label question,
            label_text,
            class: "form-question #{'hidden' if label_option == :hidden}"

    if step.help_message(question)
      p step.help_message(question), class: "text--help"
    end
  end

  def buttons
    if step.next.present?
      button type: 'submit', class: "button button--cta button--full-width" do
        text step.submit_label
        i class: "button__icon icon-arrow_forward"
      end
    end
  end
end
