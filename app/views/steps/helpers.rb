module Views::Steps::Helpers
  def step_form(step)
    div class: 'form-card' do
      form_for step, as: :step, url: step_path(step), method: :put do |f|

        if step.params
          step.params.each do |k, v|
            hidden_field_tag k, v
          end
        end

        header class: 'form-card__header' do
          section_header(step)
        end

        div class: 'form-card__content' do
          yield f
        end

        if step.previous.present? or step.next.present?
          footer class: 'form-card__footer' do
            buttons
          end
        end
      end
    end
  end

  def section_header(step)
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

      headline(step.headline)
      h3 step.subhead, class: subhead_classes

      if step.subhead_help
        p step.subhead_help,
          class: 'text--help step-section-header__subhead-help'
      end
    end
  end

  def headline(s)
    h4 s, class: "step-section-header__headline"
  end

  def buttons
    if step.next.present?
      button type: 'submit', class: "button button--cta button--full-width" do
        text step.submit_label
        i class: "button__icon icon-arrow_forward"
      end
    end
  end

  def text_field(f, method, placeholder)
    f.text_field method,
      placeholder: placeholder,
      class: 'text-input'
    errors f, method
  end

  def number_field(f, method)
    f.number_field method, class: "text-input form-width--short"
    errors f, method
  end

  def money_field(f, method, placeholder)
    div class: "text-input-group" do
      div "$", class: "text-input-group__prefix"
      f.text_field method,
        placeholder: placeholder,
        class: 'text-input text--right'
      div ".00", class: "text-input-group__postfix"
    end
    errors f, method
  end

  def text_area_field(f, method, placeholder)
    f.text_area method,
      placeholder: placeholder,
      class: 'textarea'
    errors f, method
  end

  def incrementer_field(f, method)
    div class: "incrementer" do
      span "-", class: "incrementer__subtract"
      f.number_field method, {
        class: "text-input form-width--short",
        min: 1,
        max: 30
      }
      span "+", class: "incrementer__add"
    end
    errors f, method
  end

  def select_field(f, method, options)
    div class: "select" do
      f.select method,
        options,
        { include_blank: "Choose one" },
        { class: "select__element" }
    end
    errors f, method
  end

  def radio_field(f, method, options)
    div do
      options.each do |option|
        label class: "radio-button" do
          f.radio_button method, option
          text option.titleize
        end
      end
    end
    errors f, method
  end

  def yes_no_field(f, method)
    div do
      label class: "radio-button" do
        f.radio_button method, "true"
        text "Yes"
      end

      label class: "radio-button" do
        f.radio_button method, "false"
        text "No"
      end
    end
    errors f, method
  end

  def checkbox_field(f, method, label_text)
    label class: "checkbox" do
      f.check_box method
      text label_text
    end
    errors f, method
  end

  def errors(f, method)
    if f.object.errors[method].present?
      p class: 'text--error' do
        i class: 'icon-warning'
        text " #{f.object.errors[method].to_sentence}"
      end
    end
  end
end
