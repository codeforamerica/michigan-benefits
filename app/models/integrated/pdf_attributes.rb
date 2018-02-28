module Integrated
  module PdfAttributes
    CIRCLED = "O".freeze
    UNDERLINED = "------------".freeze

    def yes_no_or_unfilled(yes: nil, no: nil)
      if yes
        "Yes"
      elsif no
        "No"
      end
    end

    def circle_if_true(statement)
      CIRCLED if statement
    end

    def mmddyyyy_date(date)
      date&.strftime("%m/%d/%Y")
    end
  end
end
