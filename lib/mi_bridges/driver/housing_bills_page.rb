# frozen_string_literal: true

module MiBridges
  class Driver
    class HousingBillsPage < BasePage
      delegate(
        :primary_member,
        to: :snap_application,
      )

      delegate :first_name, to: :primary_member

      def setup; end

      def fill_in_required_fields
        check_housing_bills
      end

      def continue
        click_on "Next"
      end

      private

      def check_housing_bills
        check_in_section section_name, if: true, for: "None"
      end

      def section_name
        "star#{first_name.capitalize}sHousingBills"
      end
    end
  end
end
