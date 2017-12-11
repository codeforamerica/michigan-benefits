module MiBridges
  class Driver
    class DependentCarePage < ClickNextPage
      def self.title
        "Dependent Care"
      end

      delegate(
        :monthly_care_expenses,
        to: :snap_application,
      )

      def setup; end

      def fill_in_required_fields
        fill_in_dependent_care_expenses
        select_dependent_care_payment_frequency
      end

      private

      def fill_in_dependent_care_expenses
        fill_in("supposedToPay_Paid", with: monthly_care_expenses)
      end

      def select_dependent_care_payment_frequency
        select("Monthly", from: "payFreqForOtherExpnses")
      end
    end
  end
end
