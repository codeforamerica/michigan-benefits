# frozen_string_literal: true

module MiBridges
  class Driver
    class MoreAboutWorkersCompensationPage < BasePage
      TITLE = /More About .*'s Workers Compensation/

      def setup; end

      def fill_in_required_fields
        fill_in(
          "How much is each payment for Workers Compensation?",
          with: snap_application.income_workers_compensation,
        )
      end

      def continue
        click_on "Next"
      end
    end
  end
end
