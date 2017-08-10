# frozen_string_literal: true

class ResidentialAddressController < AddressController
  private

  def address
    current_snap_application.addresses.where.not(mailing: true).first || current_snap_application.addresses.new(mailing: false)
  end

  def snap_application_update_params
    { snap_application_param => unstable_housing? }
  end

  def snap_application_param
    :unstable_housing
  end

  def unstable_housing?
    step_params[snap_application_param] == "1"
  end

  def skip?
    current_snap_application.mailing_address_same_as_residential_address?
  end
end
