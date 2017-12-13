module MiBridges
  class Driver
    class HousingBillsPage < FillInAndClickNextPage
      def self.title
        "Housing Bills"
      end

      delegate :primary_member, to: :snap_application

      def fill_in_required_fields
        check_housing_bills
      end

      private

      def check_housing_bills
        check_in_section section_name, condition: true, for_label: "None"
      end

      def section_name
        "star#{first_name_section(primary_member)}sHousingBills"
      end
    end
  end
end
