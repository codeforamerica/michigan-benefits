module Medicaid
  class ContactMailingAddressController < MedicaidStepsController
    private

    def existing_attributes
      HashWithIndifferentAccess.new(address.attributes)
    end

    def after_successful_update_hook
      address.update!(step_params.merge(state: "MI", county: "Genesee"))
    end

    def application_params
      {}
    end

    def skip?
      return true if no_reliable_mail_address_edge_case?
      return true if unreliable_housing?
      return true if stable_housing_and_mailing_address_same_as_residential?

      false
    end

    def no_reliable_mail_address_edge_case?
      no_reliable_mail_address? &&
        !mailing_address_same_as_residential_address?
    end

    def unreliable_housing?
      no_reliable_mail_address? && mailing_address_same_as_residential_address?
    end

    def stable_housing_and_mailing_address_same_as_residential?
      current_application.reliable_mail_address == nil &&
        mailing_address_same_as_residential_address?
    end

    def no_reliable_mail_address?
      current_application.reliable_mail_address == false
    end

    def mailing_address_same_as_residential_address?
      current_application.mailing_address_same_as_residential_address?
    end

    def address
      current_application.addresses.where(mailing: true).first ||
        current_application.addresses.new(mailing: true)
    end
  end
end
