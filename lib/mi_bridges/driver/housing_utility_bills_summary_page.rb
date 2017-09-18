# frozen_string_literal: true

module MiBridges
  class Driver
    class HousingUtilityBillsSummaryPage < ClickNextPage
      def setup
        check_page_title(
          "Housing and Utility Bills Summary",
        )
      end
    end
  end
end
