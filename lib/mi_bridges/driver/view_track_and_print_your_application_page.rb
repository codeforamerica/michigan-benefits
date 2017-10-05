# frozen_string_literal: true

module MiBridges
  class Driver
    class ViewTrackAndPrintYourApplicationPage < ClickNextPage
      def setup
        snap_application.driver_application.update(
          tracking_number: find_tracking_number,
        )
      end

      private

      def find_tracking_number
        FindTrackingNumber.new(page.html).run
      end
    end
  end
end
