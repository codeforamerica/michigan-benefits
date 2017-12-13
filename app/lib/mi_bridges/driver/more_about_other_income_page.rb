module MiBridges
  class Driver
    class MoreAboutOtherIncomePage < FillInAndClickNextPage
      def self.title
        /More About (.*)'s Other Income/
      end

      def fill_in_required_fields
        fill_in(
          "howMuchOtherIncomeAmt",
          with: snap_application.income_other,
        )
      end
    end
  end
end
