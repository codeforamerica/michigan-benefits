module Views::Widgets::Helpers
  def top_bar(title: )
    widget Views::Widgets::TopBar, title: title
  end

  def basic_form_for(*form_for_params, title:, submit: nil, &block)
    widget Views::Widgets::BasicFormFor, form_for_params: form_for_params, title: title, submit: submit, definition: block
  end

  def basic_table_for(enumerable, classes: nil, &block)
    widget Views::Widgets::BasicTableFor, enumerable: enumerable, classes: classes, definition: block
  end
end
