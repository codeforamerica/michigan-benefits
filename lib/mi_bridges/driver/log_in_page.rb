# frozen_string_literal: true

module MiBridges
  class Driver
    class LogInPage < BasePage
      def setup; end

      def fill_in_required_fields
        fill_in "User ID", with: user_id
        fill_in "Password", with: password
      end

      def continue
        click_on "User Login"
      end

      private

      def user_id
        driver_application.user_id
      end

      def password
        driver_application.password
      end

      def driver_application
        snap_application.driver_application
      end
    end
  end
end
