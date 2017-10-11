# frozen_string_literal: true

class MailingAddressController < AddressController
  include SnapFlow

  private

  def address
    current_application.addresses.where(mailing: true).first ||
      current_application.addresses.new(mailing: true)
  end

  def snap_application_update_params
    { snap_application_param => mailing_address_same_as_residential_address }
  end

  def mailing_address_same_as_residential_address
    step_params[snap_application_param]
  end

  def snap_application_param
    :mailing_address_same_as_residential_address
  end
end
