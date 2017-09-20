# frozen_string_literal: true

module MiBridges
  class Driver
    class BenefitsOverviewPage < ClickNextPage
      TITLE = "Benefits Program Overview"

      def setup
        check_page_title(TITLE)
      end
    end
  end
end
