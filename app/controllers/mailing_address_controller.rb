class MailingAddressController < SnapStepsController
  private

  def existing_attributes
    attributes = address.attributes.merge(current_application.attributes)
    HashWithIndifferentAccess.new(attributes)
  end

  def update_application
    current_application.update!(application_params)
    address.update!(address_params.merge(county: county))
  end

  def address
    current_application.addresses.where(mailing: true).first ||
      current_application.addresses.new(mailing: true)
  end

  def county
    @county ||= CountyFinder.new(
      street_address: address_params[:street_address],
      city: address_params[:city],
      zip: address_params[:zip],
      state: address_params[:state],
    ).run
  end

  def application_params
    step_params.slice(:mailing_address_same_as_residential_address)
  end

  def address_params
    step_params.
      except(:mailing_address_same_as_residential_address).
      merge(state: "MI")
  end
end
