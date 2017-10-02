# frozen_string_literal: true

module MiBridges
  class Driver
    class GoBackToApplicationPage < BasePage
      def setup; end

      def fill_in_required_fields
        choose_go_back_to_where_left_off
      end

      def continue
        click_on "Next"
      end

      private

      def choose_go_back_to_where_left_off
        click_id "radioGroup_30339"
      end
    end
  end
end
