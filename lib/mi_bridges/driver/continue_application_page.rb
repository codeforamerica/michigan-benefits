# frozen_string_literal: true

module MiBridges
  class Driver
    class ContinueApplicationPage < BasePage
      def setup; end

      def fill_in_required_fields; end

      def continue
        click_on "Continue button"
      end
    end
  end
end
