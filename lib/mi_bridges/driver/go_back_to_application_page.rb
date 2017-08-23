# frozen_string_literal: true

module MiBridges
  class Driver
    class GoBackToApplicationPage < BasePage
      def setup; end

      def fill_in_required_fields
        choose " Go back to where you stopped filling out the application."
      end

      def continue
        click_on "Next"
      end
    end
  end
end
