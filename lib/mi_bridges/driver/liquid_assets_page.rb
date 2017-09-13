# frozen_string_literal: true

module MiBridges
  class Driver
    class LiquidAssetsPage < BasePage
      delegate(
        :financial_accounts,
        :primary_member,
        :total_money?,
        to: :snap_application,
      )

      delegate :first_name, to: :primary_member

      def setup; end

      def fill_in_required_fields
        check_cash_on_hand
        check_savings_account
        check_checking_account
        check_other_liquid_assets
      end

      def continue
        click_on "Next"
      end

      private

      def check_cash_on_hand
        check_in_section(
          "starCashonHand",
          condition: total_money?,
          for_name: first_name,
        )
      end

      def check_savings_account
        check_in_section(
          "starSavingsAccount",
          condition: financial_accounts.include?("savings_account"),
          for_name: first_name,
        )
      end

      def check_checking_account
        check_in_section(
          "starCheckingAccount",
          condition: financial_accounts.include?("checking_account"),
          for_name: first_name,
        )
      end

      def check_other_liquid_assets
        check_in_section "starOtherLiquidAssets"
      end
    end
  end
end
