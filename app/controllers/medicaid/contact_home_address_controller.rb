module Medicaid
  class ContactHomeAddressController < MedicaidStepsController
    private

    def existing_attributes
      attributes = super
      residential_address = current_application.residential_address
      attributes.merge!(
        street_address: residential_address.street_address,
        city: residential_address.city,
        zip: residential_address.zip,
      )

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

    def after_successful_update_hook
      address.update!(address_params)
    end

    def application_params
      step_params.except(:street_address, :city, :zip)
    end

    def address_params
      {
        street_address: step_params[:street_address],
        city: step_params[:city],
        zip: step_params[:zip],
        county: "Genesee",
        state: "MI",
      }
    end

    def address
      current_application.addresses.where(mailing: false).first ||
        current_application.addresses.new(mailing: false)
    end
  end
end
