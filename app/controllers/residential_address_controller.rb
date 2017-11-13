class ResidentialAddressController < SnapStepsController
  private

  def update_application
    current_application.update!(stable_housing: stable_housing)
    address.update(address_params)
  end

  def address_params
    step_params.slice(:city, :county, :state, :street_address, :zip)
  end

  def existing_attributes
    attributes = address.attributes.merge(current_application.attributes)
    HashWithIndifferentAccess.new(attributes).
      merge(unstable_housing: !current_application.stable_housing?)
  end

  def address
    current_application.addresses.where.not(mailing: true).first ||
      current_application.addresses.new(mailing: false)
  end

  def stable_housing
    !step_params[:unstable_housing]
  end

  def step_params
    super.merge(state: "MI", county: "Genesee")
  end

  def skip?
    current_application&.mailing_address_same_as_residential_address?
  end
end
