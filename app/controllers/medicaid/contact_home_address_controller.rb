module Medicaid
  class ContactHomeAddressController < MedicaidStepsController
    private

    def skip?
      unstable_housing?
    end

    def unstable_housing?
      !current_application&.stable_housing?
    end
  end
end
