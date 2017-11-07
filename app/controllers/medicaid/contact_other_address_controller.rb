module Medicaid
  class ContactOtherAddressController < MedicaidStepsController
    private

    def skip?
      stable_housing?
    end

    def stable_housing?
      current_application&.stable_housing?
    end
  end
end
