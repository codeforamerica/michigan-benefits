# frozen_string_literal: true

module MiBridges
  class Driver
    class LiquidAssetsSummaryPage < ClickNextPage
      def setup
        check_page_title(
          "Liquid Assets Summary",
        )
      end
    end
  end
end
