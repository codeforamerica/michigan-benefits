class MbFormBuilder < ActionView::Helpers::FormBuilder
  def mb_input_field(method, label_text, type: "text", notes: [], options: {}, classes: [], prefix: nil, autofocus: nil)
    classes = classes.append(%w[text-input])
    <<-HTML.html_safe
      <fieldset class="form-group#{error_state(object, method)}">
        #{label_and_field(method, label_text, text_field(method, { autofocus: autofocus, type: type, class: classes.join(' '), autocomplete: 'off', autocorrect: 'off', autocapitalize: 'off', spellcheck: 'false' }.merge(options)), notes: notes, prefix: prefix)}
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
end
