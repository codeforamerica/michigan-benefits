# frozen_string_literal: true

module MiBridges
  class Driver
    class YourOtherBillsExpensesSummaryPage < ClickNextPage
      def setup
        check_page_title(
          "Other Bills / Expenses Summary",
        )
      end
    end
  end
end
