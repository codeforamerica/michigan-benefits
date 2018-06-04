module Integrated
  class MailingAddressController < FormsController
    def self.custom_skip_rule_set(application)
      application.stable_address? && application.navigator.residential_mailing_same?
    end

    def update_models
      address_params = params_for(:address)
      merged_params = address_params.merge(
        mailing: true,
        state: "MI",
        county: CountyFromZip.new(address_params[:zip]).run,
      )
      if current_application.mailing_address
        current_application.mailing_address.update(merged_params)
      else
        current_application.create_mailing_address(merged_params)
      end
    end

    private

    def existing_attributes
      HashWithIndifferentAccess.new(current_application.mailing_address&.attributes)
    end
  end
end
