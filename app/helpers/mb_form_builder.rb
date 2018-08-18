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

    text_field_options = standard_options.merge(
      autofocus: autofocus,
      type: type,
      class: classes.join(" "),
    ).merge(options).merge(error_attributes(method: method))

    text_field_options[:id] ||= sanitized_id(method)
    options[:input_id] ||= sanitized_id(method)

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

  def mb_incrementer(
    method,
    label_text,
    options: {},
    classes: [],
    hide_label: true,
    value_is_array: false,
    id_suffix: nil,
    value: 0
  )
    classes = classes.append(%w[text-input form-width--short])
    slug = [method.to_s, id_suffix].compact.join("_")

    text_field_options = standard_options.merge(
      type: "number",
      class: classes.join(" "),
      id: sanitized_id(slug),
    ).merge(options).merge(error_attributes(method: method))

    if value_is_array
      text_field_options[:multiple] = "true"
      text_field_options[:value] = value
    end

    html_output = <<~HTML
      <div class="form-group#{error_state(object, method)}">
        #{label(method, label_text, class: hide_label ? 'sr-only' : '', for: sanitized_id(slug))}
        <div class="incrementer">
          #{text_field(method, text_field_options)}
          <span class="incrementer__subtract">-</span>
          <span class="incrementer__add">+</span>
        </div>
        #{errors_for(object, method)}
      </div>
    HTML
    html_output.html_safe
  end

  def mb_money_field(
    method,
    label_text,
    type: :number,
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
      options: options.reverse_merge(maxlength: 10),
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
    text_options = standard_options.merge(
      autofocus: autofocus,
      class: classes.join(" "),
      placeholder: placeholder,
    ).merge(options).merge(error_attributes(method: method))

    <<~HTML.html_safe
      <div class="form-group#{error_state(object, method)}">
      #{label_and_field(
        method,
        label_text,
        text_area(
          method,
          text_options,
        ),
        help_text: help_text,
        options: { class: hide_label ? 'sr-only' : '' },
      )}
      #{errors_for(object, method)}
      </div>
    HTML
  end

  def mb_date_input(
    base_method,
    label_text,
    help_text: nil,
    autofocus: nil
  )
    year_method, month_method, day_method = *%i[year month day].map { |unit| :"#{base_method}_#{unit}" }

    options = standard_options.merge(
      size: 2,
      minlength: 1,
      maxlength: 2,
    )

    <<~HTML.html_safe
      <fieldset class="form-group#{error_state(object, base_method)}">
        #{fieldset_label_contents(label_text: label_text, help_text: help_text)}
        <div class="input-group--inline">
          <div class="form-group">
            <label class="text--help form-subquestion" for="#{sanitized_id(month_method)}">Month</label>
            #{telephone_field(
              month_method,
              options.merge(
                class: 'form-width--month text-input',
                id: sanitized_id(month_method),
                name: "#{object_name}[#{month_method}]",
                autofocus: autofocus,
              ),
            )}
          </div>
          <div class="form-group">
            <label class="text--help form-subquestion" for="#{sanitized_id(day_method)}">Day</label>
            #{telephone_field(
              day_method,
              options.merge(
                class: 'form-width--day text-input',
                id: sanitized_id(day_method),
                name: "#{object_name}[#{day_method}]",
              ),
            )}
          </div>
          <div class="form-group">
            <label class="text--help form-subquestion" for="#{sanitized_id(year_method)}">Year</label>
            #{telephone_field(
              year_method,
              standard_options.merge(
                class: 'form-width--year text-input',
                id: sanitized_id(year_method),
                name: "#{object_name}[#{year_method}]",
                size: 4,
                minlength: 4,
                maxlength: 4,
              ),
            )}
          </div>
        </div>
      #{errors_for(object, base_method)}
      </fieldset>
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
        #{fieldset_label_contents(label_text: label_text, help_text: help_text)}
        <div class="input-group--inline">
          <div class="select">
            <label for="#{sanitized_id(method, '2i')}" class="sr-only">Month</label>
            #{select_month(
              options[:default],
              { field_name: subfield_name(method, '2i'),
                field_id: subfield_id(method, '2i'),
                prefix: object_name,
                prompt: 'Month' }.reverse_merge(options),
              class: 'select__element',
              autofocus: autofocus,
            )}
          </div>
          <div class="select">
            <label for="#{sanitized_id(method, '3i')}" class="sr-only">Day</label>
            #{select_day(
              options[:default],
              { field_name: subfield_name(method, '3i'),
                field_id: subfield_id(method, '3i'),
                prefix: object_name,
                prompt: 'Day' }.merge(options),
              class: 'select__element',
            )}
          </div>
          <div class="select">
            <label for="#{sanitized_id(method, '1i')}" class="sr-only">Year</label>
            #{select_year(
              options[:default],
              { field_name: subfield_name(method, '1i'),
                field_id: subfield_id(method, '1i'),
                prefix: object_name,
                prompt: 'Year' }.merge(options),
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
    label_text: "",
    collection:,
    help_text: nil,
    layouts: ["block"],
    legend_class: ""
  )
    <<~HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}">
        #{fieldset_label_contents(
          label_text: label_text,
          help_text: help_text,
          legend_class: legend_class,
        )}
        #{mb_radio_button(method, collection, layouts)}
        #{errors_for(object, method)}
      </fieldset>
    HTML
  end

  def mb_checkbox_set(
    method,
    collection,
    label_text: "",
    help_text: nil,
    optional: false,
    legend_class: ""
  )
    checkbox_html = collection.map do |item|
      <<~HTML.html_safe
        <label class="checkbox">
          #{check_box(item[:method])} #{item[:label]}
        </label>
      HTML
    end.join.html_safe

    <<~HTML.html_safe
      <fieldset class="input-group form-group#{error_state(object, method)}">
        #{fieldset_label_contents(
          label_text: label_text,
          help_text: help_text,
          legend_class: legend_class,
          optional: optional,
        )}
        #{checkbox_html}
        #{errors_for(object, method)}
      </fieldset>
    HTML
  end

  def mb_checkbox_set_with_none(
    method,
    collection,
    label_text: nil,
    value_is_array: false,
    options: {}
  )

    if value_is_array
      options[:multiple] = true
    end

    checkbox_collection_html = collection.map do |item|
      checkbox_html = if value_is_array
                        check_box(method, options, item[:method].to_s, "")
                      else
                        check_box(item[:method], options)
                      end

      <<~HTML.html_safe
        <label class="checkbox">
          #{checkbox_html} #{item[:label]}
        </label>
      HTML
    end.join.html_safe

    none_html = if value_is_array
                  <<~HTML.html_safe
                    <label class="checkbox">
                      <input type="checkbox" name="#{@object_name}[#{method}][]" class="" id="none__checkbox">
                      None of the above
                    </label>
                  HTML
                else
                  <<~HTML.html_safe
                    <label class="checkbox">
                      <input type="checkbox" name="" class="" id="none__checkbox">
                      None of the above
                    </label>
                  HTML
                end

    <<~HTML.html_safe
      <fieldset class="input-group">
        <legend class="sr-only">
          #{label_text}
        </legend>
        #{checkbox_collection_html}
        <hr>
        #{none_html}
      </fieldset>
    HTML
  end

  def mb_collection_check_boxes(method, collection, value_method, text_method, label_text:, options: {})
    checkbox_collection_html = collection_check_boxes(method, collection, value_method, text_method, options) do |b|
      <<~HTML.html_safe
        <label class="checkbox">
          #{b.check_box} #{b.text}
        </label>
      HTML
    end

    <<~HTML.html_safe
      <fieldset class="input-group form-group#{error_state(object, method)}">
        <legend class="form-question">
          #{label_text}
        </legend>
        #{checkbox_collection_html}
        #{errors_for(object, method)}
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

    html_options = {
      class: "select__element",
    }

    formatted_label = label(
      method,
      label_contents(
        label_text,
        options[:help_text],
        options[:optional],
      ),
      class: options[:hide_label] ? "sr-only" : "",
    )
    html_options_with_errors = html_options.merge(error_attributes(method: method))

    html_output = <<~HTML
      <div class="form-group#{error_state(object, method)}">
        #{formatted_label}
        <div class="select">
          #{select(method, collection, options, html_options_with_errors, &block)}
        </div>
        #{errors_for(object, method)}
      </div>
    HTML

    html_output.html_safe
  end

  def mb_checkbox(method, label_text, options: {})
    checked_value = options[:checked_value] || "1"
    unchecked_value = options[:unchecked_value] || "0"

    classes = ["checkbox"]
    if options[:disabled] && object.public_send(method) == checked_value
      classes.push("is-selected")
    end
    if options[:disabled]
      classes.push("is-disabled")
    end

    options_with_errors = options.merge(error_attributes(method: method))
    <<~HTML.html_safe
      <label class="#{classes.join(' ')}">
        #{check_box(method, options_with_errors, checked_value, unchecked_value)} #{label_text}
      </label>
      #{errors_for(object, method)}
    HTML
  end

  def mb_yes_no_buttons(method, yes_value: true, no_value: false)
    <<~HTML.html_safe
      <div class="form-card__buttons">
        <div>
          <button class="button button--nav button--full-mobile" type="submit" value="#{no_value}" name="#{object_name}[#{method}]">
            No
          </button>
        </div>
        <div>
          <button class="button button--nav button--full-mobile button--cta" type="submit" value="#{yes_value}" name="#{object_name}[#{method}]">
            Yes
          </button>
        </div>
      </div>
    HTML
  end

  private

  def standard_options
    {
      autocomplete: "off",
      autocorrect: "off",
      autocapitalize: "off",
      spellcheck: "false",
    }
  end

  def mb_radio_button(method, collection, layouts)
    classes = layouts.map { |layout| "input-group--#{layout}" }.join(" ")
    options = { class: classes }.merge(error_attributes(method: method))

    radiogroup_tag = @template.tag(:radiogroup, options, true)

    radio_collection = collection.map do |item|
      item = { value: item, label: item } unless item.is_a?(Hash)

      options = item[:options].to_h

      <<~HTML.html_safe
        <label class="radio-button">
          #{radio_button(method, item[:value], options)}
          #{item[:label]}
        </label>
      HTML
    end
    <<~HTML.html_safe
      #{radiogroup_tag}
        #{radio_collection.join}
      </radiogroup>
    HTML
  end

  def fieldset_label_contents(
    label_text:,
    help_text:,
    legend_class: "",
    optional: false
  )

    label_html = <<~HTML
      <legend class="form-question #{legend_class}">
        #{label_text + optional_text(optional)}
      </legend>
    HTML

    if help_text
      label_html += <<~HTML
        <p class="text--help">#{help_text}</p>
      HTML
    end

    label_html.html_safe
  end

  def label_contents(label_text, help_text, optional)
    label_text = <<~HTML
      <p class="form-question">#{label_text + optional_text(optional)}</p>
    HTML

    if help_text
      label_text << <<~HTML
        <p class="text--help">#{help_text}</p>
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
      )
      for_options.delete(:input_id)
      for_options.delete(:maxlength)
    end

    formatted_label = label(
      method,
      label_contents(label_text, help_text, optional),
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
        <span class="text--error" id="#{error_label(method)}">
          <i class="icon-warning"></i>
          #{errors.join(', ')}
        </span>
      HTML
    end
  end

  def error_state(object, method)
    errors = object.errors[method]
    " form-group--error" if errors.any?
  end

  def subfield_id(method, position)
    "#{method}_#{position}"
  end

  def subfield_name(method, position)
    "#{method}(#{position})"
  end

  def sanitized_id(method, position = nil)
    name = object_name.to_s.gsub(/([\[\(])|(\]\[)/, "_").gsub(/[\]\)]/, "")

    position ? "#{name}_#{method}_#{position}" : "#{name}_#{method}"
  end

  def aria_label(method)
    "#{sanitized_id(method)}__label"
  end

  def error_label(method)
    "#{sanitized_id(method)}__errors"
  end

  def error_attributes(method:)
    object.errors.present? ? { "aria-describedby": error_label(method) } : {}
  end

  # copied from ActionView::FormHelpers in order to coerce strings with spaces
  # and capitalization to snake case, using the same logic as Rails
  def sanitized_value(value)
    value.to_s.gsub(/\s/, "_").gsub(/[^-[[:word:]]]/, "").mb_chars.downcase.to_s
  end
end
