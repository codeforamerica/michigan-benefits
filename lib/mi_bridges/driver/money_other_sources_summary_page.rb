# frozen_string_literal: true

module MiBridges
  class Driver
    class MoneyOtherSourcesSummaryPage < ClickNextPage
      def setup
        check_page_title(
          "Other Income Summary",
        )
      end
    end
  end
end
