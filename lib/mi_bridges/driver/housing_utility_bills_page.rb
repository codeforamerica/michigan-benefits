# frozen_string_literal: true

module MiBridges
  class Driver
    class HousingUtilityBillsPage < BasePage
      delegate(
        :primary_member,
        to: :snap_application,
      )

      delegate :first_name, to: :primary_member

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
        check_in_section "starHousingBills", if: true, for: first_name
      end

      def check_utility_bills
        check_in_section "starUtilityBills", if: true, for: first_name
      end

      def check_room_and_meals
        check_in_section "starRoomandMeals"
      end

      def select_home_heating_payment
        check_in_section "heatingResponseGroup", if: true, for: "No"
        check_in_section "meapReceivedGroup", if: true, for: "No"
      end
    end
  end
end
