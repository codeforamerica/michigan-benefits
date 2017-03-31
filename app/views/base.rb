module Views
  class Base < Fortitude::Widget
    include Views::Widgets::Helpers
    include Rails.application.routes.url_helpers

    doctype :html5

    private

    def slab_with_card
      div class: "slab slab--not-padded" do
        div class: "card card--narrow" do
          yield
        end
      end
    end

    def help_text(text)
      p text, class: "text--help"
    end

    def small_text(text=nil)
      if block_given?
        p class: "text--small" do
          yield
        end
      else
        p text, class: "text--small"
      end
    end

    def safety(text)
      p class: "text--secure" do
        i class: "illustration illustration--safety"
        text text
      end
    end

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
