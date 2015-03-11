class Views::LoggedOut::TakeAction < Views::Base
  def content
    wide_row(:'background-cover') {
      div(class: %[clear-panel text-center]) {

      }
    }

  end

  private

  def wide_row(add_class)
    classes = [:fullWidth]
    classes << add_class
    row(class: classes) {
      column {
        row {
          column(:'medium-8', class: :'medium-offset-2') {
            br
            yield
          }
        }
      }
    }
  end
end
