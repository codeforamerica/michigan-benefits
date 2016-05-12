module Views::Widgets::Helpers
  def top_bar(title: )
    widget Views::Widgets::TopBar, title: title
  end

  def basic_form_for(*form_for_params, title:, &block)
    widget Views::Widgets::BasicFormFor, form_for_params: form_for_params, title: title, definition: block
  end
end
