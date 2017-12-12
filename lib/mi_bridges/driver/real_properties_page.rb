module MiBridges
  class Driver
    class RealPropertiesPage < FillInAndClickNextPage
      def self.title
        "Real Properties"
      end

      def fill_in_required_fields
        click_other_real_properties_box
      end

      private

      def click_other_real_properties_box
        click_id "assetOther_1"
      end
    end
  end
end
