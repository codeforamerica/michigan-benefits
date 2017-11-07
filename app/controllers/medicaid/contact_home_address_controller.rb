module Medicaid
  class ContactHomeAddressController < MedicaidStepsController
    private

    def existing_attributes
      attributes = super

      if attributes[:mailing_address_same_as_residential_address].nil?
        attributes[:mailing_address_same_as_residential_address] = true
      end

      attributes
    end

    def skip?
      unstable_housing?
    end

    def unstable_housing?
      !current_application&.stable_housing?
    end
  end
end
