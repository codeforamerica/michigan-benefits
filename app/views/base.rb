module Views
  class Base < Fortitude::Widget
    doctype :html5

    private

    def row(args = {}, &block)
      classes = [:row]
      classes += Array(args.fetch(:class, []))
      div(args.merge(class: classes), &block)
    end

    def column(size = :'small-12', args = {}, &block)
      classes = [:columns, size]
      classes += Array(args.fetch(:class, []))
      div(args.merge(class: classes), &block)
    end

    def full_row
      row { column { yield } }
    end

    def buttonish(size = :small, *extras)
      result = %i[button radius]
      result << size
      result.concat extras
    end

    def with_errors(object, field)
      errors = object.errors[field]
      if errors.any?
        div(class: :error) {
          yield
          small(class: :error) { text errors.to_sentence }
        }
      else
        yield
      end
    end

    def to_json(*args)
      as_json(*args).to_json
    end
  end
end
