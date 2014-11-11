module Views
  class EmailBase < Fortitude::Widget
    doctype :xhtml10_transitional

    # Premailer `convert_to_text` doesn't understand comments, and inlines part
    # of urls passed in the assigns.
    start_and_end_comments false

    private

    # http://zurb.com/ink/docs.php#grid
    def row(args = {}, &block)
      table(class: :container) {
        tr {
          td {
            table {
              tr(add_classes(args, [:row]), &block)
              # technically, more rows are allowed in a container, but this is
              # easier?
            }
          }
        }
      }
    end

    # http://zurb.com/ink/docs.php#grid, see Full-Width Rows
    def wide_row(args = {}, &block)
      table(add_classes(args, [:row])) {
        tr {
          center_td {
            table(class: :container) {
              tr(&block)
            }
          }
        }
      }
    end

    # http://zurb.com/ink/docs.php#grid
    def column(size = :twelve, args = {})
      td(class: :wrapper) {
        table(add_classes(args, [size, :columns])) {
          tr {
            yield # must return a td, or a series of tds for sub-grids

            td(class: :expander)
          }
        }
      }
    end

    # http://zurb.com/ink/docs.php#grid
    def last_column(size = :twelve, args = {})
      td(class: [:wrapper, :last]) {
        table(add_classes(args, [size, :columns])) {
          tr {
            yield # must return a td, or a series of tds for sub-grids

            td(class: :expander)
          }
        }
      }
    end

    def full_row(args = {}, &block)
      row(args) { last_column(&block) }
    end

    # http://zurb.com/ink/docs.php#grid, see Centered Content
    def center_td(args = {}, &block)
      td(add_classes(args, [:center]).merge(align: :center)) { center(&block) }
    end

    # def buttonish(size = :small, *extras)
    # end

    def add_classes(args, classes)
      classes += Array(args.fetch(:class, []))
      args.merge(class: classes)
    end
  end
end
