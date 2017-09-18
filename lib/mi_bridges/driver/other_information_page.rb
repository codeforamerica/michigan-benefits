module MiBridges
  class Driver
    class OtherInformationPage < ClickNextPage
      def setup
        check_page_title(
          "Other Information",
        )
      end
    end
  end
end
