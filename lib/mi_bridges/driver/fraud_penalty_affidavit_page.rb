# frozen_string_literal: true

module MiBridges
  class Driver
    class FraudPenaltyAffidavitPage < ClickNextPage
      TITLE = "Fraud Penalty Affidavit"

      def setup
        check_page_title(TITLE)
      end
    end
  end
end
