class AddressController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_snap_application.update!(snap_application_update_params)
      address.update(step_params.except(snap_application_param))
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def existing_attributes
    HashWithIndifferentAccess.new(address_attributes)
  end

  def address_attributes
    address.attributes.merge(snap_application_update_params)
  end

  def step_params
    super.merge(state: "MI", county: "Genesee")
  end
end
