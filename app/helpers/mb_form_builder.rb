class MbFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::DateHelper

  def mb_input_field(
    method,
    label_text,
    type: "text",
    help_text: nil,
    options: {},
    classes: [],
    prefix: nil,
    autofocus: nil,
    optional: false
  )
    classes = classes.append(%w[text-input])

    text_field_options = {
      autofocus: autofocus,
      type: type,
      class: classes.join(" "),
      autocomplete: "off",
      autocorrect: "off",
      autocapitalize: "off",
      spellcheck: "false",
    }.merge(options)

    text_field_options[:id] ||= "#{object_name}_#{method}"
    options[:input_id] ||= "#{object_name}_#{method}"

    aria_labels = ["#{text_field_options[:id]}__label"]
    aria_labels << "#{text_field_options[:id]}__help" if help_text
    if object.errors.present?
      aria_labels.unshift("#{text_field_options[:id]}__errors")
    end
    text_field_options["aria-labelledby"] = aria_labels.join(" ")

    text_field_html = text_field(method, text_field_options)

    label_and_field_html = label_and_field(
      method,
      label_text,
      text_field_html,
      help_text: help_text,
      prefix: prefix,
      optional: optional,
      options: options,
    )

    html_output = <<~HTML
      <div class="form-group#{error_state(object, method)}">
      #{label_and_field_html}
      #{errors_for(object, method)}
      </div>
    HTML
    html_output.html_safe
  end

  def mb_money_field(
    method,
    label_text,
    type: :tel,
    help_text: nil,
    options: {},
    classes: [],
    prefix: "$",
    autofocus: nil,
    optional: false
  )

    mb_input_field(
      method,
      label_text,
      type: type,
      help_text: help_text,
      options: options,
      classes: classes,
      prefix: prefix,
      autofocus: autofocus,
      optional: optional,
    )
  end

  def mb_phone_number_field(
    method,
    label_text,
    type: :tel,
    help_text: nil,
    options: {},
    classes: [],
    prefix: "+1",
    autofocus: nil,
    optional: false
  )
    mb_input_field(
      method,
      label_text,
      type: type,
      help_text: help_text,
      options: options,
      classes: classes,
      prefix: prefix,
      autofocus: autofocus,
      optional: optional,
    )
  end

  def mb_form_errors(method)
    errors = object.errors[method]
    if errors.any?
      <<~HTML.html_safe
        <div class="form-group#{error_state(object, method)}">
          #{errors_for(object, method)}
        </div>
      HTML
    end
  end

  def mb_textarea(
    method,
    label_text,
    help_text: nil,
    options: {},
    classes: [],
    placeholder: nil,
    autofocus: nil,
    hide_label: false
  )
    classes = classes.append(%w[textarea])

    <<~HTML.html_safe
      <div class="form-group#{error_state(object, method)}">
      #{label_and_field(
        method,
        label_text,
        text_area(
          method,
          {
            autofocus: autofocus,
            class: classes.join(' '),
            autocomplete: 'off',
            autocorrect: 'off',
            autocapitalize: 'off',
            spellcheck: 'false',
            placeholder: placeholder,
          }.merge(options),
        ),
        help_text: help_text,
        options: { class: hide_label ? 'sr-only' : '' },
      )}
      #{errors_for(object, method)}
      </div>
    HTML
  end

  def mb_date_select(
    method,
    label_text,
    help_text: nil,
    options: {},
    autofocus: nil
  )
    <<~HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}">
        #{fieldset_label_contents(method: method, label_text: label_text, help_text: help_text)}
        <div class="input-group--inline">
          <div class="select">
            <label for="#{select_label_for(object_name, method, '2i')}" class="sr-only">Month</label>
            #{select_month(
              options[:default],
              { field_name: select_field_name(method, '2i'),
                field_id: select_field_id(method, '2i'),
                prefix: object_name }.merge(options),
              class: 'select__element',
              autofocus: autofocus,
            )}
          </div>
          <div class="select">
            <label for="#{select_label_for(object_name, method, '3i')}" class="sr-only">Day</label>
            #{select_day(
              options[:default],
              { field_name: select_field_name(method, '3i'),
                field_id: select_field_id(method, '3i'),
                prefix: object_name }.merge(options),
              class: 'select__element',
            )}
          </div>
          <div class="select">
            <label for="#{select_label_for(object_name, method, '1i')}" class="sr-only">Year</label>
            #{select_year(
              options[:default],
              { field_name: select_field_name(method, '1i'),
                field_id: select_field_id(method, '1i'),
                prefix: object_name }.merge(options),
              class: 'select__element',
            )}
          </div>
        </div>
        #{errors_for(object, method)}
      </fieldset>
    HTML
  end

  def mb_radio_set(
    method,
    label_text:,
    collection:,
    help_text: nil,
    layout: "block",
    legend_class: ""
  )
    <<~HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}">
        #{fieldset_label_contents(
          method: method,
          label_text: label_text,
          help_text: help_text,
          legend_class: legend_class,
        )}
        #{mb_radio_button(method, collection, layout, help_text)}
        #{errors_for(object, method)}
      </fieldset>
    HTML
  end

  def mb_checkbox_set(
    method,
    collection,
    label_text:,
    help_text: nil,
    optional: false,
    legend_class: ""
  )
    aria_labels = ["#{object_name}_#{method}__label"]
    aria_labels << "#{object_name}_#{method}__help" if help_text

    checkbox_html = collection.map do |item|
      checkbox_label_id = "#{object_name}_#{method}_#{item[:method]}__label"
      options = {
        'aria-labelledby': (aria_labels + [checkbox_label_id]).join(" "),
      }

      <<~HTML.html_safe
        <label id="#{checkbox_label_id}" class="checkbox">
          #{check_box(item[:method], options)} #{item[:label]}
        </label>
        #{errors_for(object, item[:method])}
      HTML
    end.join.html_safe

    <<~HTML.html_safe
      <fieldset class="input-group">
        #{fieldset_label_contents(
          label_text: label_text,
          help_text: help_text,
          legend_class: legend_class,
          optional: optional,
          method: method,
        )}
        #{checkbox_html}
      </fieldset>
    HTML
  end

  def mb_select(
    method,
    label_text,
    collection,
    options = {},
    &block
  )
    html_options = { class: "select__element" }

    formatted_label = label(
      method,
      label_contents(
        label_text,
        options[:help_text],
        options[:optional],
      ),
      class: options[:hide_label] ? "sr-only" : "",
    )

    html_output = <<~HTML
      <div class="form-group#{error_state(object, method)}">
        #{formatted_label}
        <div class="select">
          #{select(method, collection, options, html_options, &block)}
        </div>
        #{errors_for(object, method)}
      </div>
    HTML

    html_output.html_safe
  end

  def mb_checkbox(method, label_text, options = {})
    checked_value = options[:checked_value] || "1"
    unchecked_value = options[:unchecked_value] || "0"

    <<~HTML.html_safe
      <label class="checkbox">
        #{check_box(method, options, checked_value, unchecked_value)} #{label_text}
      </label>
      #{errors_for(object, method)}
    HTML
  end

  private

  def mb_radio_button(method, collection, layout, help_text)
    radio_html = <<~HTML
      <radiogroup class="input-group--#{layout}">
    HTML
    collection.map do |item|
      item = { value: item, label: item } unless item.is_a?(Hash)

      help_text_label = help_text ? "#{object_name}_#{method}__help" : nil
      snake_case_value = sanitized_value(item[:value])

      aria_labels = [
        object.errors.present? ? "#{object_name}_#{method}__errors" : nil,
        "#{object_name}_#{method}__label",
        help_text_label,
        "#{object_name}_#{method}_#{snake_case_value}__label",
      ].compact.flatten

      options = {
        'aria-labelledby': aria_labels.join(" "),
      }

      radio_html << <<~HTML.html_safe
        <label class="radio-button" id="#{object_name}_#{method}_#{snake_case_value}__label">
          #{radio_button(method, item[:value], options)}
          #{item[:label]}
        </label>
      HTML
    end
    radio_html << <<~HTML
      </radiogroup>
    HTML
    radio_html.html_safe
  end

  def fieldset_label_contents(
    method:,
    label_text:,
    help_text:,
    legend_class: "",
    optional: false
  )

    label_text = <<~HTML
      <legend class="form-question #{legend_class}" id="#{object_name}_#{method}__label">#{label_text + optional_text(optional)}</legend>
    HTML
    if help_text
      label_text << <<~HTML
        <p class="text--help" id="#{object_name}_#{method}__help">#{help_text}</p>
      HTML
    end

    label_text.html_safe
  end

  def label_contents(label_text, help_text, optional = false, method = nil)
    label_text = <<~HTML
      <p class="form-question">#{label_text + optional_text(optional)}</p>
    HTML

    if help_text
      label_text << <<~HTML
        <p class="text--help" id="#{object_name}_#{method}__help">#{help_text}</p>
      HTML
    end

    label_text.html_safe
  end

  def optional_text(optional)
    if optional
      "<span class='form-card__optional'>(optional)</span>"
    else
      ""
    end
  end

  def label_and_field(
    method,
    label_text,
    field,
    help_text: nil,
    prefix: nil,
    optional: false,
    options: {}
  )
    if options[:input_id]
      for_options = options.merge(
        for: options[:input_id],
        id: "#{options[:input_id]}__label",
      )
      for_options.delete(:input_id)
    end

    formatted_label = label(
      method,
      label_contents(label_text, help_text, optional, method),
      (for_options || options),
    )
    if prefix
      <<~HTML
        #{formatted_label}
        <div class="text-input-group">
          <div class="text-input-group__prefix">#{prefix}</div>
          #{field}
        </div>
      HTML
    else
      formatted_label + field
    end
  end

  def errors_for(object, method)
    errors = object.errors[method]
    if errors.any?
      <<~HTML
        <div class="text--error" id="#{object_name}_#{method}__errors">
          <i class="icon-warning"></i>
          #{errors.join(', ')}
        </div>
      HTML
    end
  end

  def error_state(object, method)
    errors = object.errors[method]
    " form-group--error" if errors.any?
  end

  def select_field_id(method, position)
    "#{method}_#{position}"
  end

  def select_field_name(method, position)
    "#{method}(#{position})"
  end

  def select_label_for(object_name, method, position)
    object_name.to_s.gsub(/([\[\(])|(\]\[)/, "_").gsub(/[\]\)]/, "") + "_" +
      select_field_id(method, position)
  end

  # copied from ActionView::FormHelpers in order to coerce strings with spaces
  # and capitalization to snake case, using the same logic as Rails
  def sanitized_value(value)
    value.to_s.gsub(/\s/, "_").gsub(/[^-[[:word:]]]/, "").mb_chars.downcase.to_s
  end
end
