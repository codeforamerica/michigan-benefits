# frozen_string_literal: true

module MiBridges
  class Driver
    class JobIncomeSummaryPage < ClickNextPage
      def setup
        check_page_title(
          "Job Income Summary",
        )
      end
    end
  end
end
