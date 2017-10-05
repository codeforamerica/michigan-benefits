# frozen_string_literal: true

module MiBridges
  class Driver
    class LogInPage < BasePage
      delegate :latest_drive_attempt, to: :snap_application

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
        latest_drive_attempt.user_id
      end

      def password
        latest_drive_attempt.password
      end
    end
  end
end
