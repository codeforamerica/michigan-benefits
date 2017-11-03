module MiBridges
  class Driver
    class MoreAboutCheckingAccountPage < BasePage
      def self.title
        /More About (.*)'s Checking Account/
      end

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
