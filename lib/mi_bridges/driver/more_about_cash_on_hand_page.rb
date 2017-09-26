# frozen_string_literal: true

module MiBridges
  class Driver
    class MoreAboutCashOnHandPage < BasePage
      TITLE = /More About (.*)'s Cash on Hand/

      def setup; end

      def fill_in_required_fields
        if snap_application.total_money.present?
          fill_in "How much money does", with: snap_application.total_money
        else
          click_id("#iDontknow")
        end
      end

      def continue
        click_on "Next"
      end
    end
  end
end
