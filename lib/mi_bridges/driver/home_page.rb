# frozen_string_literal: true

module MiBridges
  class Driver
    class HomePage < BasePage
      def setup
        visit "https://www.mibridges.michigan.gov/access/"
      end

      def fill_in_required_fields; end

      def continue
        click_on "Create An Account"
      end
    end
  end
end
