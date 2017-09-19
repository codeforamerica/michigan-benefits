# frozen_string_literal: true

module MiBridges
  class Driver
    class OtherAssetsPage < BasePage
      delegate(
        :financial_accounts,
        :primary_member,
        :real_estate_income?,
        :vehicle_income?,
        to: :snap_application,
      )

      delegate :first_name, to: :primary_member

      def setup
        check_page_title(
          "Other Assets",
        )
      end

      def fill_in_required_fields
        check_vehicles
        check_real_estate
        check_burial_assets
        check_life_insurance
        check_additional_assets
        check_selling_or_giving_away
      end

      def continue
        click_on "Next"
      end

      private

      def check_vehicles
        check_in_section(
          "starVehicles",
          condition: vehicle_income?,
          for_label: first_name,
        )
      end

      def check_real_estate
        check_in_section(
          "starRealEstate",
          condition: real_estate_income?,
          for_label: first_name,
        )
      end

      def check_burial_assets
        check_in_section "starBurialAssets"
      end

      def check_life_insurance
        check_in_section(
          "starLifeInsurance",
          condition: financial_accounts.include?("life_insurance"),
          for_label: first_name,
        )
      end

      def check_additional_assets
        check_in_section "starAdditionalAssets"
      end

      def check_selling_or_giving_away
        check_in_section "starSellingorGivingAwayAssets"
      end
    end
  end
end
