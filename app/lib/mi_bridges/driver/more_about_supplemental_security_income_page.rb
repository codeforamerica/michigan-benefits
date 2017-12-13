module MiBridges
  class Driver
    class MoreAboutSupplementalSecurityIncomePage < FillInAndClickNextPage
      def self.title
        /More About (.*)'s Supplemental Security Income \(SSI\)/
      end

      def fill_in_required_fields
        fill_in(
          "How much is each payment for Supplemental Security Income (SSI)?",
          with: snap_application.income_ssi_or_disability,
        )
      end
    end
  end
end
