module Integrated
  class ResidentialAddressController < FormsController
    def self.skip?(application)
      application.unstable_housing?
    end

    def update_models
      address_params = params_for(:address)
      merged_params = address_params.merge(
        mailing: false,
        state: "MI",
        county: CountyFromZip.new(address_params[:zip]).run,
      )
      if current_application.residential_address
        current_application.residential_address.update(merged_params)
      else
        current_application.create_residential_address(merged_params)
      end
      current_application.navigator.update(params_for(:navigator))
    end

    private

    def existing_attributes
      HashWithIndifferentAccess.new(
        current_application.navigator.attributes.merge(
          Hash(current_application.residential_address&.attributes),
        ),
      )
    end
  end
end
