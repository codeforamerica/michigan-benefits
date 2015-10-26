module Views
  # Quick Tutorial on Structuring Emails
  #
  # We're using Zurb Ink to make structured, responsive emails. Ink doesn't get
  # away from tables (that's still not possible) but it helps you style them.
  #
  # This file has a number of helpers for generating the nested tables that are
  # required.  See the [Zurb docs](http://zurb.com/ink/docs.php) for
  # background, details and more possibilities.
  #
  # For the most part, you can use the `row` and `column` helpers that should
  # be familiar from Views::Base.  They work slightly differently and have some
  # caveats, explained here.
  #
  # 1. Columns do not have small/medium/large variants; their sizes are
  #    spelled-out numbers: *three*, *four*, *six*, *twelve*, etc.  All columns
  #    collapse at 580px.
  # 2. The last column in a row must use the `last_column` helper.
  # 3. Rows are not nestable.  You may want to look at sub-grids (non-
  #    responsive) or block-grids (which collapse according to usual div rules)
  #    if you need something similar to nested rows.
  # 4. The block passed to `column` or `full_row` must return a `td`, or a
  #    series of `td`s if you are using sub-grids.
  #
  # There are also helpers for centering content, creating buttons and creating
  # full-width rows.
  #
  # There are no helpers, yet, for sub-grids, block-grids, panels, retina-
  # images, or hidden content for small screens, though they may all be
  # possible.
  class EmailBase < Fortitude::Widget
    doctype :xhtml10_transitional

    # Premailer `convert_to_text` doesn't understand comments, and inlines part
    # of urls passed in the assigns.
    start_and_end_comments false

    private

    def container(&block)
      table(class: :container) { tr(&block) }
    end

    # http://zurb.com/ink/docs.php#grid
    def row(args = {}, &block)
      container {
        td {
          table(class: :row) {
            tr(add_classes(args, []), &block)
            # technically, more rows are allowed in a container, but this is
            # easier?
          }
        }
      }
    end

    # http://zurb.com/ink/docs.php#grid, see Full-Width Rows
    def wide_row(args = {}, &block)
      table(add_classes(args, [:row])) {
        tr {
          center_td {
            container(&block)
          }
        }
      }
    end

    # http://zurb.com/ink/docs.php#grid
    def column(size = :twelve, args = {})
      wrapper_args = args.delete(:wrapper) || {}
      td(add_classes(wrapper_args, [:wrapper])) {
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

    def block_grid(size, args = {})
      container {
        td {
          table(class: "block-grid #{size}-up") {
            tr {
              yield # series of td's
            }
          }
        }
      }
    end

    def center_img(src, args = {})
      center_td(args) { image_tag src, html: { width: args[:width], height: args[:height] } }
    end

    # http://zurb.com/ink/docs.php#grid, see Centered Content
    def center_td(args = {}, &block)
      td(add_classes(args, [:center]).merge(align: :center)) { center(&block) }
    end

    def buttonish(size = :small, args = {}, &block)
      table(add_classes(args, ["#{size}-button"])) { tr { td(&block) } }
    end

    def add_classes(args, classes)
      classes += Array(args.fetch(:class, []))
      args.merge(class: classes)
    end
  end
end
