module MiBridges
  class Driver
    class VehiclesPage < FillInAndClickNextPage
      def self.title
        "Vehicles"
      end

      def fill_in_required_fields
        click_other_vehicles_box
      end

      private

      def click_other_vehicles_box
        click_id "assetOther_1"
      end
    end
  end
end
