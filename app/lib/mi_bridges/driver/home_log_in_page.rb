module MiBridges
  class Driver
    class HomeLogInPage < BasePage
      delegate :latest_drive_attempt, to: :snap_application

      def setup
        latest_drive_attempt.update(driven_at: DateTime.current)
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
        latest_drive_attempt.user_id
      end

      def password
        latest_drive_attempt.password
      end
    end
  end
end
