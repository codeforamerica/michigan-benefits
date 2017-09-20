# frozen_string_literal: true

module MiBridges
  class Driver
    class HousingUtilityBillsPage < BasePage
      TITLE = "Housing and Utility Bills"

      delegate :primary_member, to: :snap_application

      def setup; end

      def fill_in_required_fields
        check_housing_bills
        check_utility_bills
        check_room_and_meals
        select_home_heating_payment
      end

      def continue
        click_on "Next"
      end

      private

      def check_housing_bills
        check_in_section(
          "starHousingBills",
          condition: true,
          for_label: primary_member.first_name_and_age,
        )
      end

      def check_utility_bills
        check_in_section(
          "starUtilityBills",
          condition: true,
          for_label: primary_member.first_name_and_age,
        )
      end

      def check_room_and_meals
        check_in_section "starRoomandMeals"
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
