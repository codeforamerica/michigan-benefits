# frozen_string_literal: true

module MiBridges
  class Driver
    class MoreAboutSupplementalSecurityIncomePage < BasePage
      def self.title
        /More About (.*)'s Supplemental Security Income \(SSI\)/
      end

      def setup; end

      def fill_in_required_fields
        fill_in(
          "How much is each payment for Supplemental Security Income (SSI)?",
          with: snap_application.income_ssi_or_disability,
        )
      end

      def continue
        click_on "Next"
      end
    end
  end
end
