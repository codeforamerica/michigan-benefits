module Views::Widgets::Helpers
  def top_bar(title: )
    widget Views::Widgets::TopBar, title: title
  end
end
