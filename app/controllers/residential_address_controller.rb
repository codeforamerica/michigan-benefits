class ResidentialAddressController < SnapStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_application.update!(stable_housing: stable_housing)
      address.update(step_params.except(:unstable_housing))
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

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
