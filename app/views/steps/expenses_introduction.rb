# frozen_string_literal: true

class Views::Steps::ExpensesIntroduction < Views::Base
  def content
    slab_with_card do
      h3 <<-TEXT
        In this section, we will ask you to document your expenses for
        things like housing, medicine, dependent care and more.
      TEXT

      help_text <<-TEXT
        Sometime soon, you’ll be asked to provide documentation for
        those. You can share photos of receipts, bills and statements
        on this website, or send them by mail or fax later.
      TEXT

      h4 <<-TEXT
        Expenses have a big impact on increasing the amount of
        assistance you may qualify for.
      TEXT

      help_text <<-TEXT
        If you aren't sure about exact numbers right now — that's
        okay. Do your best and we will work with you to clarify later.
      TEXT
    end
  end
end
