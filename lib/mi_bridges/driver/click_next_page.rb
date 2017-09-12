# frozen_string_literal: true

module MiBridges
  class Driver
    class ClickNextPage < BasePage
      def setup; end

      def fill_in_required_fields; end

      def continue
        click_on "Next"
      end
    end
  end
end
