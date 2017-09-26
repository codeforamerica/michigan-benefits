# frozen_string_literal: true

module MiBridges
  class Driver
    class MoreAboutDisabilityBenefitsPage < BasePage
      TITLE = /More About .*'s Disability Benefits/

      def setup; end

      def fill_in_required_fields
        fill_in(
          "How much is each payment for Disability Benefits?",
          with: snap_application.income_ssi_or_disability,
        )
      end

      def continue
        click_on "Next"
      end
    end
  end
end
