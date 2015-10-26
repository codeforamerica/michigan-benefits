module Views
  class Base < Fortitude::Widget
    doctype :html5

    private

    def row(args = {}, &block)
      div(add_classes(args, [:row]), &block)
    end

    def column(size = 'small-12', args = {}, &block)
      div(add_classes(args, [:columns, size]), &block)
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
          small(errors.to_sentence, class: :error)
        }
      else
        yield
      end
    end

    def to_json(*args)
      as_json(*args).to_json
    end

    def add_classes(args, classes)
      classes += Array(args.fetch(:class, []))
      args.merge(class: classes)
    end
  end

  def current_account
    current_user
  end
end
