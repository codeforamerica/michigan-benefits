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
    append_html: ""
  )
    classes = classes.append(%w[text-input])
    <<-HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}">
        #{label_and_field(method, label_text, text_field(method, { autofocus: autofocus, type: type, class: classes.join(' '), autocomplete: 'off', autocorrect: 'off', autocapitalize: 'off', spellcheck: 'false' }.merge(options)), notes: notes, prefix: prefix)}
        #{errors_for(object, method)}
        #{append_html}
      </fieldset>
    HTML
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

  def mb_checkbox_set(collection, label_text: nil, notes: [])
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
        #{label_contents(label_text, notes)}
      HTML
      checkbox_html = label_html + checkbox_html
    end

    checkbox_html
  end

  def mb_select(method, label_text, collection, options = {}, &block)
    <<-HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}">
        #{label(method, label_contents(label_text, options[:notes]))}
        <div class="select">
          #{select(method, collection, options, { class: 'select__element' }, &block)}
        </div>
        #{errors_for(object, method)}
      </fieldset>
    HTML
  end

  private

  def label_contents(label_text, notes)
    notes = Array(notes)
    label_text = <<-HTML
      <p class="form-question">#{label_text}</p>
    HTML
    notes.each do |note|
      label_text << <<-HTML
        <p class="text--help">#{note}</p>
      HTML
    end
    label_text.html_safe
  end

  def label_and_field(method, label_text, field, notes: [], prefix: nil)
    if prefix
      <<-HTML
        #{label(method, label_contents(label_text, notes))}
        <div class="text-input-group">
          <div class="text-input-group__prefix">#{prefix}</div>
          #{field}
        </div>
      HTML
    else
      label(method, label_contents(label_text, notes)) + field
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

  def mb_checkbox(method, label_text)
    <<-HTML.html_safe
      <label class="checkbox">
    #{check_box_with_label(label_text, method)}
      </label>
    #{errors_for(object, method)}
    HTML
  end

  def check_box_with_label(label_text, method)
    <<-HTML.html_safe
    #{check_box(method)} #{label_text}
    HTML
  end
end
