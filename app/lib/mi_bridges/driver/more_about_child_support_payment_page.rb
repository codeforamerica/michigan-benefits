module MiBridges
  class Driver
    class MoreAboutChildSupportPaymentPage < ClickNextPage
      def self.title
        /More About (.*)'s Child \/ Spousal Support Payment/
      end
    end
  end
end
