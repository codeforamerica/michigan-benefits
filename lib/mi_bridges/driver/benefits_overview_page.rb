# frozen_string_literal: true

module MiBridges
  class Driver
    class BenefitsOverviewPage < BasePage
      def setup
        check_page_title("Benefits Program Overview")
      end

      def fill_in_required_fields; end

      def continue
        click_on "Next"
      end
    end
  end
end
