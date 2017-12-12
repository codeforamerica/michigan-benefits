module MiBridges
  class Driver
    class MoreAboutUnemploymentBenefitsPage < FillInAndClickNextPage
      def self.title
        /More About (.*)'s Unemployment Benefits/
      end

      def fill_in_required_fields
        fill_in(
          "How much is each payment for Unemployment Benefits?",
          with: snap_application.income_unemployment_insurance,
        )
      end
    end
  end
end
