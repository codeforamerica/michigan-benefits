# frozen_string_literal: true

module MiBridges
  class Driver
    class OtherAssetsSummaryPage < ClickNextPage
      def setup
        check_page_title(
          "Other Assets Summary",
        )
      end
    end
  end
end
