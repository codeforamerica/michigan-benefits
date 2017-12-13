module MiBridges
  class Driver
    class MoreAboutCheckingAccountPage < FillInAndClickNextPage
      def self.title
        /More About (.*)'s Checking Account/
      end

      def fill_in_required_fields
        click_id "#iDontknow"
      end
    end
  end
end
