module Views
  class Base < Fortitude::Widget
    include Views::Widgets::Helpers

    doctype :html5

    private

    def row(classes=[], expanded: true, &block)
      classes = CssClasses.new(classes, ("expanded" if expanded), "row")
      div class: classes.to_s, &block
    end

    def columns(classes=[], small: 12, medium: nil, large: nil, &block)
      classes = CssClasses.new(
        classes,
        "columns",
        ("small-#{small}" if small.present?),
        ("medium-#{medium}" if medium.present?),
        ("large-#{large}" if large.present?)
      )
      div class: classes.to_s, &block
    end
    alias :column :columns
  end
end
