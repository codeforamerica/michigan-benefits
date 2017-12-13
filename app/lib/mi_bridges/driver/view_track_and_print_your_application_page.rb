module MiBridges
  class Driver
    class ViewTrackAndPrintYourApplicationPage < ClickNextPage
      def self.title
        "View, Track And Print Your Application"
      end

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
