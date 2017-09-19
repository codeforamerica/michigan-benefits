# frozen_string_literal: true

module MiBridges
  class Driver
    class DisabilityOrBlindnessReviewPage < ClickNextPage
      def setup
        check_page_title(
          "Review Your Answers: Disability or Blindness",
        )
      end
    end
  end
end
