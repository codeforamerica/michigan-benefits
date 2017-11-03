class ResidentialAddressController < AddressController
  private

  def address
    current_application.addresses.where.not(mailing: true).first ||
      current_application.addresses.new(mailing: false)
  end

  def snap_application_update_params
    { snap_application_param => unstable_housing }
  end

  def unstable_housing
    step_params[snap_application_param]
  end

  def snap_application_param
    :unstable_housing
  end

  def skip?
    current_application&.mailing_address_same_as_residential_address?
  end
end
