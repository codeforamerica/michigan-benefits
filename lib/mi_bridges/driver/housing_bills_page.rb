# frozen_string_literal: true

module MiBridges
  class Driver
    class HousingBillsPage < BasePage
      delegate(
        :primary_member,
        to: :snap_application,
      )

      def setup; end

      def fill_in_required_fields
        check_housing_bills
      end

      def continue
        click_on "Next"
      end

      private

      def check_housing_bills
        check_in_section section_name, condition: true, for_label: "None"
      end

      def section_name
        "star#{first_name_section(primary_member).capitalize}sHousingBills"
      end
    end
  end
end
