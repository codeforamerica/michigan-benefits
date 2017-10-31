# frozen_string_literal: true

module Medicaid
  class IntroCaretakerController < MedicaidStepsController
    private

    def skip?
      single_member_household?
    end
  end
end
