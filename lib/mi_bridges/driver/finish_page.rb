module MiBridges
  class Driver
    class FinishPage < ClickNextPage
      def setup
        check_page_title(
          "Getting Expedited Food Assistance Program Benefits",
        )
      end
    end
  end
end
