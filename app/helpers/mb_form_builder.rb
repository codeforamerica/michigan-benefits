class MbFormBuilder < ActionView::Helpers::FormBuilder
  def mb_input_field(
    method,
    label_text,
    type: "text",
    notes: [],
    options: {},
    classes: [],
    prefix: nil,
    autofocus: nil,
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

      label_and_field_html = label_and_field(
        method,
        label_text&.gsub("{index}", (i + 1).to_s),
        text_field_html,
        notes: notes,
        prefix: prefix,
        optional: optional,
        options: options,
      )

      <<~HTML
        <fieldset class="form-group#{error_state(object, method)}">
        #{label_and_field_html}
        #{errors_for(object, method)}
        #{append_html}
        </fieldset>
      HTML
    end.join.html_safe
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

  def mb_money_field(
    method,
    label_text,
    type: :tel,
    notes: [],
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
      notes: notes,
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
      <<-HTML.html_safe
        <fieldset class="form-group#{error_state(object, method)}">
          #{errors_for(object, method)}
        </fieldset>
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
    autofocus: nil
  )
    classes = classes.append(%w[textarea])
    <<-HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}">
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
      )}
      #{errors_for(object, method)}
      </fieldset>
    HTML
  end

  def mb_date_select(method, label_text, notes: [], options: {}, autofocus: nil)
    <<-HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}">
        #{label(method, label_contents(label_text, notes))}
        <div class="input-group--inline">
          <div class="select">
            #{date_select(method, { autofocus: autofocus, date_separator: '</div><div class="select">' }.merge(options), class: 'select__element')}
          </div>
        </div>
        #{errors_for(object, method)}
      </fieldset>
    HTML
  end

  def mb_radio_set(
    method,
    label_text,
    collection,
    notes: [],
    layout: "block",
    variant: "",
    classes: []
  )
    <<-HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}#{(' ' + classes.join(' ')).strip}">
        #{label_contents(label_text, notes)}
        #{radio_buttons(method, collection, layout, variant)}
        #{errors_for(object, method)}
      </fieldset>
    HTML
  end

  def mb_checkbox_set(collection, label_text: nil, notes: [], optional: false)
    checkbox_html = <<-HTML.html_safe
      <fieldset class="input-group">
    HTML

    checkbox_html << collection.map do |item|
      method = item[:method]
      label = item[:label]
      mb_checkbox(method, label)
    end.join.html_safe

    checkbox_html << <<-HTML.html_safe
      </fieldset>
    HTML

    if label_text || notes
      label_html = <<-HTML.html_safe
        #{label_contents(label_text, notes, optional)}
      HTML
      checkbox_html = label_html + checkbox_html
    end

    checkbox_html
  end

  def mb_select(
    method,
    label_text,
    collection,
    options = {},
    &block
  )
    <<-HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}">
        #{label(method, label_contents(label_text, options[:notes], options[:optional]))}
        <div class="select">
          #{select(method, collection, options, { class: 'select__element' }, &block)}
        </div>
        #{errors_for(object, method)}
      </fieldset>
    HTML
  end

  def mb_checkbox(method, label_text, options = {})
    <<-HTML.html_safe
      <label class="checkbox">
    #{check_box_with_label(label_text, method, options)}
      </label>
    #{errors_for(object, method)}
    HTML
  end

  private

  def label_contents(label_text, notes, optional = false)
    notes = Array(notes)
    optional_text = if optional
                      "<span class='form-card__optional'>(optional)</span>"
                    else
                      ""
                    end

    label_text = <<-HTML
      <p class="form-question">#{label_text + optional_text}</p>
    HTML
    notes.each do |note|
      label_text << <<-HTML
        <p class="text--help">#{note}</p>
      HTML
    end

    label_text.html_safe
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
      <<-HTML
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
      <<-HTML
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

  def radio_buttons(method, collection, layout, variant)
    variant_class = " #{variant}" if variant.present?
    radio_html = <<-HTML
      <radiogroup class="input-group--#{layout}#{variant_class}">
    HTML
    collection.map do |item|
      item = { value: item, label: item } unless item.is_a?(Hash)

      input_html = item.fetch(:input_html, {})

      radio_html << <<-HTML.html_safe
        <label class="radio-button">
          #{radio_button(method, item[:value], input_html)}
          #{item[:label]}
        </label>
      HTML
    end
    radio_html << <<-HTML
      </radiogroup>
    HTML
    radio_html
  end

  def check_box_with_label(label_text, method, options = {})
    checked_value = options[:checked_value] || "1"
    unchecked_value = options[:unchecked_value] || "0"
    <<-HTML.html_safe
      #{check_box(method, options, checked_value, unchecked_value)} #{label_text}
    HTML
  end
end
