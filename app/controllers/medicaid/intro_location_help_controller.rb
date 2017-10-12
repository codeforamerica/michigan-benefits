# frozen_string_literal: true

module Medicaid
  class IntroLocationHelpController < StandardStepsController
    include MedicaidFlow

    private

    def skip?
      michigan_resident?
    end

    def michigan_resident?
      current_application&.michigan_resident?
    end
  end
end
