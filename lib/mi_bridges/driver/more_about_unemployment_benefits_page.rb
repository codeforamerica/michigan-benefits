# frozen_string_literal: true

module MiBridges
  class Driver
    class MoreAboutUnemploymentBenefitsPage < BasePage
      TITLE = /More About (.*)'s Unemployment Benefits/

      def setup; end

      def fill_in_required_fields
        fill_in(
          "How much is each payment for Unemployment Benefits?",
          with: snap_application.income_unemployment_insurance,
        )
      end

      def continue
        click_on "Next"
      end
    end
  end
end
