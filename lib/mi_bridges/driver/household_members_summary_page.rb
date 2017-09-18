# frozen_string_literal: true

module MiBridges
  class Driver
    class HouseholdMembersSummaryPage < ClickNextPage
      def setup
        check_page_title(
          "Household Members Summary",
        )
      end
    end
  end
end
