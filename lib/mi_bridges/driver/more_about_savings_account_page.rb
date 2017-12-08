module MiBridges
  class Driver
    class MoreAboutSavingsAccountPage < ClickNextPage
      def self.title
        /More About (.*)'s Savings Account/
      end
    end
  end
end
