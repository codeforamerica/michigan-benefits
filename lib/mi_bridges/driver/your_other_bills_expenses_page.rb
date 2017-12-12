module MiBridges
  class Driver
    class YourOtherBillsExpensesPage < FillInAndClickNextPage
      def self.title
        "Your Other Bills / Expenses"
      end

      delegate(
        :court_ordered?,
        :monthly_medical_expenses?,
        :primary_member,
        to: :snap_application,
      )

      def fill_in_required_fields
        check_child_spousal_payments
        check_dependent_care_bills
        check_medical_bills
        check_medicare
      end

      private

      def check_child_spousal_payments
        check_in_section(
          "starChildSpousalSupportPayments",
          condition: court_ordered?,
          for_label: primary_member.mi_bridges_formatted_name,
        )
      end

      def check_dependent_care_bills
        check_no_one_in_section "starDependentCareBills"
      end

      def check_medical_bills
        check_in_section(
          "starMedicalBills",
          condition: monthly_medical_expenses?,
          for_label: primary_member.mi_bridges_formatted_name,
        )
      end

      def check_medicare
        check_no_one_in_section "starMedicarePartAorPartB"
      end
    end
  end
end
