module MiBridges
  class Driver
    class HousingUtilityBillsPage < FillInAndClickNextPage
      def self.title
        "Housing and Utility Bills"
      end

      delegate :primary_member, to: :snap_application

      def fill_in_required_fields
        check_housing_bills
        check_utility_bills
        check_room_and_meals
        select_home_heating_payment
      end

      private

      def check_housing_bills
        check_in_section(
          "starHousingBills",
          condition: true,
          for_label: primary_member.mi_bridges_formatted_name,
        )
      end

      def check_utility_bills
        check_in_section(
          "starUtilityBills",
          condition: true,
          for_label: primary_member.mi_bridges_formatted_name,
        )
      end

      def check_room_and_meals
        check_no_one_in_section "starRoomandMeals"
      end

      def select_home_heating_payment
        check_in_section(
          "heatingResponseGroup",
          condition: true,
          for_label: "No",
        )
        check_in_section(
          "meapReceivedGroup",
          condition: true,
          for_label: "No",
        )
      end
    end
  end
end
