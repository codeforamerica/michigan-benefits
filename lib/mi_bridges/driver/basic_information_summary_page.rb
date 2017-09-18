# frozen_string_literal: true

module MiBridges
  class Driver
    class BasicInformationSummaryPage < ClickNextPage
      def setup
        check_page_title(
          "Basic Information Summary",
        )
      end
    end
  end
end
