# frozen_string_literal: true

module MiBridges
  class Driver
    class YourOtherBillsExpensesPage < BasePage
      delegate(
        :court_ordered?,
        :monthly_medical_expenses?,
        :primary_member,
        to: :snap_application,
      )

      delegate :first_name, to: :primary_member

      def setup; end

      def fill_in_required_fields
        check_child_spousal_payments
        check_medical_bills
        check_medicare
      end

      def continue
        click_on "Next"
      end

      private

      def check_child_spousal_payments
        check_in_section(
          "starChildSpousalSupportPayments",
          if: court_ordered?,
          for: first_name,
        )
      end

      def check_medical_bills
        check_in_section(
          "starMedicalBills",
          if: monthly_medical_expenses?,
          for: first_name,
        )
      end

      def check_medicare
        check_in_section "starMedicarePartAorPartB"
      end
    end
  end
end
