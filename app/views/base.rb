module Views
  class Base < Fortitude::Widget
    include Views::Widgets::Helpers

    doctype :html5

    private

    def row(classes=[], &block)
      class_array = classes_to_a(classes)
      class_array << "row"

      div class: class_array, &block
    end

    def columns(classes=[], small: 12, medium: nil, large: nil, &block)
      class_array = classes_to_a(classes)
      class_array << "columns"
      class_array << "small-#{small}" if small.present?
      class_array << "medium-#{medium}" if medium.present?
      class_array << "large-#{large}" if large.present?

      div class: class_array, &block
    end
    alias :column :columns

    def classes_to_a(string_or_array)
      if string_or_array.is_a?(Array)
        string_or_array
      else
        string_or_array.to_s.split(" ")
      end
    end

  end
end
