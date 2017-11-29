class ResidentialAddressController < SnapStepsController
  private

  def update_application
    current_application.update!(application_params)
    address.update(address_params.merge(county: county))
  end

  def address_params
    step_params.
      except(:unstable_housing).
      merge(state: "MI")
  end

  def application_params
    { stable_housing: !unstable_housing }
  end

  def existing_attributes
    attributes = address.attributes.merge(current_application.attributes)
    HashWithIndifferentAccess.new(attributes).
      merge(unstable_housing: !current_application.stable_housing?)
  end

  def address
    current_application.addresses.where(mailing: false).first ||
      current_application.addresses.new(mailing: false)
  end

  def unstable_housing
    step_params[:unstable_housing] == "1"
  end

  def county
    @county ||= CountyFinder.new(
      street_address: address_params[:street_address],
      city: address_params[:city],
      zip: address_params[:zip],
      state: address_params[:state],
    ).run
  end

  def skip?
    current_application&.mailing_address_same_as_residential_address?
  end
end
