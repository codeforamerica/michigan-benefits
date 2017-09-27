# frozen_string_literal: true

module MiBridges
  class Driver
    class VehiclesPage < BasePage
      TITLE = "Vehicles"

      def setup; end

      def fill_in_required_fields
        click_other_vehicles_box
      end

      def continue
        click_on "Next"
      end

      private

      def click_other_vehicles_box
        click_id "assetOther_1"
      end
    end
  end
end
