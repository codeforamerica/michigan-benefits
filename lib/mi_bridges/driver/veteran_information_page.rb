module MiBridges
  class Driver
    class VeteranInformationPage < ClickNextPage
      def setup
        check_page_title(
          "Veteran Information",
        )
      end
    end
  end
end
