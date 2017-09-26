# frozen_string_literal: true

module MiBridges
  class Driver
    class MoreAboutCheckingAccountPage < BasePage
      TITLE = /More About (.*)'s Checking Account/

      def setup; end

      def fill_in_required_fields
        click_id "#iDontknow"
      end

      def continue
        click_on "Next"
      end
    end
  end
end
