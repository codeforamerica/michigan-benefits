module Medicaid
  class ContactHomeAddressController < MedicaidStepsController
    private

    def existing_attributes
      addr_attributes = address.attributes.merge(current_application.attributes)
      attributes = HashWithIndifferentAccess.new(addr_attributes)

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

    def update_application
      current_application.update!(
        same_address_key => step_params[same_address_key],
      )
      address.update!(step_params.except(same_address_key))
    end

    def step_params
      super.merge(state: "MI", county: "Genesee")
    end

    def address
      current_application.addresses.where(mailing: false).first ||
        current_application.addresses.new(mailing: false)
    end

    def same_address_key
      :mailing_address_same_as_residential_address
    end
  end
end
