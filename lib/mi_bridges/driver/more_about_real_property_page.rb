module MiBridges
  class Driver
    class MoreAboutRealPropertyPage < ClickNextPage
      def self.title
        /More About (.*)'s Other Real Property/
      end
    end
  end
end
