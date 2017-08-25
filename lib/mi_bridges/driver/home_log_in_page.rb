# frozen_string_literal: true

module MiBridges
  class Driver
    class HomeLogInPage < BasePage
      def setup
        visit "https://www.mibridges.michigan.gov/access/"
      end

      def fill_in_required_fields
        fill_in "User ID", with: user_id
        fill_in "Password", with: password
      end

      def continue
        click_on "LOGIN"
      end

      private

      def user_id
        current_application.user_id
      end

      def password
        current_application.password
      end

      def current_application
        snap_application.driver_application
      end
    end
  end
end
