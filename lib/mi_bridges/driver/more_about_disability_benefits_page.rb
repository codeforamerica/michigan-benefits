module MiBridges
  class Driver
    class MoreAboutDisabilityBenefitsPage < FillInAndClickNextPage
      def self.title
        /More About (.*)'s Disability Benefits/
      end

      def fill_in_required_fields
        fill_in(
          "How much is each payment for Disability Benefits?",
          with: snap_application.income_ssi_or_disability,
        )
      end
    end
  end
end
