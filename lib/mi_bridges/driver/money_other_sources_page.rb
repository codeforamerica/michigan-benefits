# frozen_string_literal: true

module MiBridges
  class Driver
    class MoneyOtherSourcesPage < BasePage
      TITLE = "Money From Other Sources"

      delegate(
        :income_other?,
        :income_child_support?,
        :income_ssi_or_disability?,
        :primary_member,
        to: :snap_application,
      )

      def setup; end

      def fill_in_required_fields
        check_retirement_survivors_disability_insurance
        check_child_support_income
        check_other_income
        check_supplemental_security_income
        check_room_and_meals
      end

      def continue
        click_on "Next"
      end

      private

      def check_retirement_survivors_disability_insurance
        check_no_one_in_section "starRetirementSurvivorsDisabilityInsuranceRSDI"
      end

      def check_other_income
        check_in_section(
          "starOtherIncome",
          condition: income_other?,
          for_label: primary_member.mi_bridges_formatted_name,
        )
      end

      def check_child_support_income
        check_no_one_in_section "starChildSupport"
      end

      def check_supplemental_security_income
        check_in_section(
          "starSupplementalSecurityIncomeSSI",
          condition: income_ssi_or_disability?,
          for_label: primary_member.mi_bridges_formatted_name,
        )
      end

      def check_room_and_meals
        check_no_one_in_section "starRoomandMeals"
      end
    end
  end
end
