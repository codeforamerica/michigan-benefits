# frozen_string_literal: true

module MiBridges
  class Driver
    class MoreAboutOtherIncomePage < BasePage
      def self.title
        /More About (.*)'s Other Income/
      end

      def setup; end

      def fill_in_required_fields
        fill_in(
          "howMuchOtherIncomeAmt",
          with: snap_application.income_other,
        )
      end

      def continue
        click_on "Next"
      end
    end
  end
end
