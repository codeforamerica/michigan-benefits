module Medicaid
  class IntroCaretakerController < MedicaidStepsController
    private

    def skip?
      single_member_household?
    end
  end
end
