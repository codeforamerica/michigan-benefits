module MiBridges
  class Driver
    class MoreAboutWorkersCompensationPage < BasePage
      def self.title
        /More About (.*)'s Workers Compensation/
      end

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
