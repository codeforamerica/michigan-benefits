module MiBridges
  class Driver
    class RentOrLotRentPage < ClickNextPage
      def self.title
        /(.*)'s Rent or Lot Rent/
      end
    end
  end
end
