class MbFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::DateHelper

  def mb_input_field(
    method,
    label_text,
    type: "text",
    notes: [],
    options: {},
    classes: [],
    prefix: nil,
    autofocus: nil,
    prepend_html: "",
    append_html: "",
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

    field_values(text_field_options, method).map.with_index do |value, i|
      if array_of_values?(method)
        text_field_options[:name] = "#{object_name}[#{method}][]"
        text_field_options[:id] = "#{object_name}_#{method}_#{i}"
        options[:id] = "#{object_name}_#{method}_#{i}"
      end

      text_field_options[:value] = value

      text_field_html = text_field(method, text_field_options)

      field_index = (i + 1).to_s
      rendered_prepend_html = prepend_html&.gsub("{index}", field_index)
      rendered_append_html = append_html&.gsub("{index}", field_index)
      rendered_label_text = label_text&.gsub("{index}", field_index)

      label_and_field_html = label_and_field(
        method,
        rendered_label_text,
        text_field_html,
        notes: notes,
        prefix: prefix,
        optional: optional,
        options: options,
      )

      <<~HTML
        <div class="form-group#{error_state(object, method)}">
        #{rendered_prepend_html}
        #{label_and_field_html}
        #{errors_for(object, method)}
        #{rendered_append_html}
        </div>
      HTML
    end.join.html_safe
  end

  def mb_money_field(
    method,
    label_text,
    type: :tel,
    notes: [],
    options: {},
    classes: [],
    prefix: "$",
    autofocus: nil,
    prepend_html: "",
    append_html: "",
    optional: false
  )

    mb_input_field(
      method,
      label_text,
      type: type,
      notes: notes,
      options: options,
      classes: classes,
      prefix: prefix,
      autofocus: autofocus,
      prepend_html: prepend_html,
      append_html: append_html,
      optional: optional,
    )
  end

  def mb_phone_number_field(
    method,
    label_text,
    type: :tel,
    notes: [],
    options: {},
    classes: [],
    prefix: "+1",
    autofocus: nil,
    prepend_html: "",
    append_html: "",
    optional: false
  )
    mb_input_field(
      method,
      label_text,
      type: type,
      notes: notes,
      options: options,
      classes: classes,
      prefix: prefix,
      autofocus: autofocus,
      prepend_html: prepend_html,
      append_html: append_html,
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
    notes: [],
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
        notes: notes,
        options: { class: hide_label ? 'sr-only' : '' },
      )}
      #{errors_for(object, method)}
      </div>
    HTML
  end

  def mb_date_select(
    method,
    label_text,
    notes: [],
    options: {},
    autofocus: nil
  )
    <<~HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}">
        #{fieldset_label_contents(label_text: label_text, notes: notes)}
        <div class="input-group--inline">
          <div class="select">
            <label for="#{object_name}_#{select_field_id(method, '2i')}" class="sr-only">Month</label>
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
            <label for="#{object_name}_#{select_field_id(method, '3i')}" class="sr-only">Day</label>
            #{select_day(
              options[:default],
              { field_name: select_field_name(method, '3i'),
                field_id: select_field_id(method, '3i'),
                prefix: object_name }.merge(options),
              class: 'select__element',
            )}
          </div>
          <div class="select">
            <label for="#{object_name}_#{select_field_id(method, '1i')}" class="sr-only">Year</label>
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
    notes: [],
    layout: "block",
    legend_class: ""
  )
    <<~HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}">
        #{fieldset_label_contents(
          label_text: label_text,
          notes: notes,
          legend_class: legend_class,
        )}
        #{mb_radio_button(method, collection, layout)}
        #{errors_for(object, method)}
      </fieldset>
    HTML
  end

  def mb_checkbox_set(
    collection,
    label_text:,
    notes: [],
    optional: false,
    legend_class: ""
  )
    checkbox_html = ""
    collection.map do |item|
      checkbox = <<~HTML.html_safe
        <label class="checkbox">
        #{check_box_with_label(item[:label], item[:method])}
        </label>
        #{errors_for(object, item[:method])}
      HTML
      checkbox_html << checkbox
    end

    <<~HTML.html_safe
      <fieldset class="input-group">
        #{fieldset_label_contents(
          label_text: label_text,
          notes: notes,
          legend_class: legend_class,
          optional: optional,
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
    field_values(options, method).map.with_index do |value, i|
      html_options = { class: "select__element" }

      if array_of_values?(method)
        html_options[:name] = "#{object_name}[#{method}][]"
        html_options[:id] = "#{object_name}_#{method}_#{i}"
        options[:selected] = value
      end

      field_index = (i + 1).to_s
      rendered_label_text = label_text&.gsub("{index}", field_index)
      formatted_label = label(
        method,
        label_contents(
          rendered_label_text,
          options[:notes],
          options[:optional],
        ),
        class: options[:hide_label] ? "sr-only" : "",
      )

      <<~HTML
        <div class="form-group#{error_state(object, method)}">
          #{formatted_label}
          <div class="select">
            #{select(method, collection, options, html_options, &block)}
          </div>
          #{errors_for(object, method)}
        </div>
      HTML
    end.join.html_safe
  end

  def mb_checkbox(method, label_text, options = {})
    <<~HTML.html_safe
      <label class="checkbox">
        #{check_box_with_label(label_text, method, options)}
      </label>
      #{errors_for(object, method)}
    HTML
  end

  def field_values(options, method)
    current_value = object.send(method)
    return Array.wrap(current_value) if current_value.present?

    if options[:count] && current_value.blank?
      Array.new(options[:count], "")
    else
      [""]
    end
  end

  def array_of_values?(attribute)
    object.respond_to?(:hash_key_attribute?) &&
      object.hash_key_attribute?(attribute)
  end

  def mb_radio_button(method, collection, layout)
    radio_html = <<~HTML
      <radiogroup class="input-group--#{layout}">
    HTML
    collection.map do |item|
      item = { value: item, label: item } unless item.is_a?(Hash)

      input_html = item.fetch(:input_html, {})

      radio_html << <<~HTML.html_safe
        <label class="radio-button">
          #{radio_button(method, item[:value], input_html)}
          #{item[:label]}
        </label>
      HTML
    end
    radio_html << <<~HTML
      </radiogroup>
    HTML
    radio_html.html_safe
  end

  private

  def fieldset_label_contents(
    label_text:,
    notes:,
    legend_class: "",
    optional: false
  )

    notes = Array(notes)
    label_text = <<~HTML
      <legend class="form-question #{legend_class}">#{label_text + optional_text(optional)}</legend>
    HTML
    notes.each do |note|
      label_text << <<~HTML
        <p class="text--help">#{note}</p>
      HTML
    end

    label_text.html_safe
  end

  def label_contents(label_text, notes, optional = false)
    notes = Array(notes)

    label_text = <<~HTML
      <p class="form-question">#{label_text + optional_text(optional)}</p>
    HTML
    notes.each do |note|
      label_text << <<~HTML
        <p class="text--help">#{note}</p>
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
    notes: [],
    prefix: nil,
    optional: false,
    options: {}
  )
    if options[:id]
      for_options = options.merge(for: options[:id])
      for_options.delete(:id)
    end

    formatted_label = label(
      method,
      label_contents(label_text, notes, optional),
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
        <div class="text--error">
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

  def check_box_with_label(label_text, method, options = {})
    checked_value = options[:checked_value] || "1"
    unchecked_value = options[:unchecked_value] || "0"
    <<~HTML.html_safe
      #{check_box(method, options, checked_value, unchecked_value)} #{label_text}
    HTML
  end

  def select_field_id(method, position)
    "#{method}_#{position}"
  end

  def select_field_name(method, position)
    "#{method}(#{position})"
  end
end
