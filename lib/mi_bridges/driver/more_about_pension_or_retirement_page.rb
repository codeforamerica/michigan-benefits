# frozen_string_literal: true

module MiBridges
  class Driver
    class MoreAboutPensionOrRetirementPage < BasePage
      TITLE = /More About .*'s Pension or Retirement/

      def setup; end

      def fill_in_required_fields
        fill_in(
          "How much is each payment from this Pension or Retirement account?",
          with: snap_application.income_pension,
        )
      end

      def continue
        click_on "Next"
      end
    end
  end
end
