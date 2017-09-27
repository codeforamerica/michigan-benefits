# frozen_string_literal: true

module MiBridges
  class Driver
    class RealPropertiesPage < BasePage
      TITLE = "Real Properties"

      def setup; end

      def fill_in_required_fields
        click_other_real_properties_box
      end

      def continue
        click_on "Next"
      end

      private

      def click_other_real_properties_box
        click_id "assetOther_1"
      end
    end
  end
end
