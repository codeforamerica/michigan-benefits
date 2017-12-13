module MiBridges
  class Driver
    class MoreAboutCashOnHandPage < FillInAndClickNextPage
      def self.title
        /More About (.*)'s Cash on Hand/
      end

      def fill_in_required_fields
        if snap_application.total_money.present?
          fill_in "How much money does", with: snap_application.total_money
        else
          click_id("#iDontknow")
        end
      end
    end
  end
end
