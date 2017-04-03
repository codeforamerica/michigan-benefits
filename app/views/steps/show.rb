class Views::Steps::Show < Views::Base
  needs :step

  def content
    content_for :header_title, header_title
    content_for :back_path, back_path

    if Rails.env.development?
      div class: "debug" do
        text step.nav.progress
        text " | "
        text step.class.name
        text " | app "
        text current_user.app.id
        text " | "
        link_to "Nav", steps_path
      end
    end

    step_form(step) do |f|
      if lookup_context.template_exists? "steps/#{step.template}"
        render partial: step.template, locals: { f: f }
      else
        questions(f)
      end
    end
  end

  private

  def back_path
    if step.previous
      step_path(step.previous.to_param)
    else
      root_path
    end
  end

  def header_title
    step.title.html_safe
  end

  def questions(f)
    general_questions(f)
    member_questions(f)
    household_questions(f)
    member_grouped_questions(f)
  end

  def member_questions(f)
    step.member_questions.each do |question, (label_text, label_option)|
      current_user.app.household_members.each do |member|
        headline(member.reflected_name)

        f.fields_for "household_members[]", member, hidden_field_id: true do |member_fields|
          question_field(member_fields, question, label_text, label_option)
        end
      end
    end
  end

  def household_questions(f)
    step.household_questions.each do |question, (label_text, label_option)|
      div class: "form-questions-group",
        "data-field-type" => step.type(question),
        "data-md5" => Digest::MD5.hexdigest(label_text) do
        question_label(f, question, label_text, label_option)

        current_user.app.household_members.each do |member|
          f.fields_for "household_members[]", member, hidden_field_id: true do |member_fields|
            question_field(member_fields, question, member.first_name.titleize, label_option)
          end
        end
      end
    end
  end

  def member_grouped_questions(f)
    return if step.member_grouped_questions.empty?

    current_user.app.household_members.each do |member|
      h4 member.first_name.titleize, class: "step-section-header__headline"

      f.fields_for "household_members[]", member, hidden_field_id: true do |member_fields|
        step.member_grouped_questions.each do |question, (label_text, label_option)|
          question_field(member_fields, question, label_text, label_option)
        end
      end
    end
  end

  def general_questions(f)
    step.questions.each do |question, (label_text, label_option)|
      question_field(f, question, label_text, label_option)
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

  def question_field(f, question, label_text, label_option)
    group_classes = 'form-group'

    if step.errors[question].present?
      group_classes += ' form-group--error'
    end

    field_option = step.options_for(question)

    if field_option.present? && field_option.is_a?(Hash)
      group_classes += " #{field_option[:form_group_class]}"
    end

    field_type = step.type(question)

    div class: group_classes,
      'data-field-type' => field_type, '
      data-md5' => Digest::MD5.hexdigest(label_text) do
      headline step.section_header(question) if step.section_header(question)

      if step.overview(question)
        p step.overview(question)
      end

      case field_type
        when :number
          question_label(f, question, label_text, label_option)
          number_field f, question

        when :text
          question_label(f, question, label_text, label_option)
          text_field f, question, step.placeholder(question)

        when :money
          question_label(f, question, label_text, label_option)
          money_field f, question, step.placeholder(question)

        when :text_area
          question_label(f, question, label_text, label_option)
          text_area_field f, question, step.placeholder(question)

        when :incrementer
          question_label(f, question, label_text, label_option)
          incrementer_field f, question

        when :select
          f.label question, label_text, class: 'form-question'
          select_field f, question, step.options_for(question).map(&:titleize)

        when :radios
          question_label(f, question, label_text, label_option)
          radio_field f, question, step.options_for(question)

        when :yes_no
          question_label(f, question, label_text, label_option)
          yes_no_field f, question

        when :checkbox
          if step.help_message(question)
            p step.help_message(question), class: "text--help"
          end
          checkbox_field f, question, label_text

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

      if step.safety(question)
        safety step.safety(question)
      end

    end
  end
end
