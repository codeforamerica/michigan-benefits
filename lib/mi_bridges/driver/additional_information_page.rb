module MiBridges
  class Driver
    class AdditionalInformationPage < ClickNextPage
      def setup
        check_page_title(
          "Additional Information",
        )
      end

      def fill_in_required_fields
        fill_in(
          "addUsrComments",
          with: snap_application.additional_information,
        )
      end
    end
  end
end
