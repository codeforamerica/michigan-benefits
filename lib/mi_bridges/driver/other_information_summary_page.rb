module MiBridges
  class Driver
    class OtherInformationSummaryPage < ClickNextPage
      def setup
        check_page_title(
          "Other Information Summary",
        )
      end
    end
  end
end
